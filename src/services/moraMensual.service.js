const db = require("../config/db");

async function calcularMoraMensual(cicloAnterior) {
  const pool = db.promise();

  console.log("🟦 Calculando mora del ciclo:", cicloAnterior);

  const cicloNuevo = obtenerSiguienteMes(cicloAnterior);

  const [prestamos] = await pool.query(`
    SELECT id FROM prestamos WHERE estado = 'activo'
  `);

  for (const prestamo of prestamos) {
  const prestamoId = prestamo.id; // ✅ MOVER ESTO ARRIBA

  // 🔒 Verificar si ya existe mora para este ciclo
  const [existe] = await pool.query(`
      SELECT id FROM moras_mensuales
      WHERE prestamo_id = ? AND ciclo = ?
      LIMIT 1
      `, [prestamoId, cicloAnterior]);

  if (existe.length > 0) {
    console.log(`⛔ Mora ya existe para préstamo ${prestamoId} ciclo ${cicloAnterior}`);
    continue;
  }

    const [cuotas] = await pool.query(
      `
      SELECT
      id, 
      monto, 
      COALESCE(saldo, monto) AS saldo
      FROM cuotas
      WHERE prestamo_id = ?
        AND DATE_FORMAT(fecha_pago, '%Y-%m') = ?
        AND COALESCE(saldo, monto) > 0
      `,
      [prestamoId, cicloAnterior]
    );

    if (cuotas.length === 0) continue;

    let totalImpago = 0;

    for (const cuota of cuotas) {
      totalImpago += Number(cuota.saldo);
    }

    const tasaMora = 2;
    const moraCalculada = Number((totalImpago * 0.02).toFixed(2));

    if (moraCalculada <= 0) continue;

    const [result] = await pool.query(
      `
      INSERT IGNORE INTO moras_mensuales
        (prestamo_id, ciclo, total_base, tasa_mora, mora_calculada, fecha_calculo, estado)
      VALUES (?, ?, ?, ?, ?, CURDATE(), 'pendiente')
      `,
      [prestamoId, cicloAnterior, totalImpago, tasaMora, moraCalculada]
    );

    if (result.insertId) {
      await repartirMoraMensual(
        pool,
        result.insertId,
        prestamoId,
        moraCalculada,
        cicloNuevo
      );
    }

    console.log(
      `✅ Mora préstamo ${prestamoId}: Base $${totalImpago} → Mora $${moraCalculada}`
    );
  }

  console.log("✅ Cálculo de mora finalizado");
}

function obtenerSiguienteMes(ciclo) {
  const [anio, mes] = ciclo.split("-").map(Number);

  const fecha = new Date(anio, mes - 1);
  fecha.setMonth(fecha.getMonth() + 1);

  return `${fecha.getFullYear()}-${String(fecha.getMonth() + 1).padStart(2, "0")}`;
}

async function repartirMoraMensual(
  pool,
  moraMensualId,
  prestamoId,
  moraTotal,
  ciclo
) {
  const db = require("../config/db");
  const conn = await db.promise().getConnection();

  try {
    await conn.beginTransaction();

    let restante = moraTotal;

    const [cuotas] = await conn.query(
      `
      SELECT id, monto
      FROM cuotas
      WHERE prestamo_id = ?
        AND DATE_FORMAT(fecha_pago, '%Y-%m') = ?
        AND estado != 'pagada'
      ORDER BY fecha_pago ASC
      `,
      [prestamoId, ciclo]
    );

    for (const cuota of cuotas) {
      if (restante <= 0) break;

      // 🔥 1. Ver cuánto ya tiene acumulado esa cuota
      const [moraExistente] = await conn.query(`
        SELECT COALESCE(SUM(monto_asignado), 0) AS total
        FROM moras_mensuales_cuotas
        WHERE cuota_id = ?
      `, [cuota.id]);

      const acumulado = Number(moraExistente[0].total);

      // 🔥 2. límite total (20%)
      const limiteTotal = Number((cuota.monto * 0.2).toFixed(2));

      // 🔥 3. disponible real
      const disponible = limiteTotal - acumulado;

      if (disponible <= 0) {
        continue;
      }

      // 🔥 4. aplicar sin pasarse
      const aplicar = Math.min(disponible, restante);

      if (aplicar <= 0) continue; // 🛡️ protección extra

      console.log(
        `💰 Cuota ${cuota.id}: acumulado ${acumulado}, disponible ${disponible}, aplicar ${aplicar}`
      );

      await conn.query(
        `
        INSERT INTO moras_mensuales_cuotas
          (mora_mensual_id, cuota_id, monto_asignado)
        VALUES (?, ?, ?)
        `,
        [moraMensualId, cuota.id, aplicar]
      );

      await conn.query(
        `
        UPDATE cuotas
        SET saldo = saldo + ?
        WHERE id = ?
        `,
        [aplicar, cuota.id]
      );

      restante -= aplicar;
    }

    // ✅ marcar mora como aplicada
    await conn.query(
      `
      UPDATE moras_mensuales
      SET estado = 'aplicada'
      WHERE id = ?
      `,
      [moraMensualId]
    );

    await conn.commit();

  } catch (error) {
    await conn.rollback();
    console.error("❌ Error en reparto de mora:", error);
    throw error;

  } finally {
    conn.release();
  }
}

module.exports = {
  calcularMoraMensual
};