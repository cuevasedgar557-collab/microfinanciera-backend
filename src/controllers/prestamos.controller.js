const db = require("../config/db");

/*
====================================================
FERIADOS NACIONALES NICARAGUA (MM-DD)
====================================================
*/
const FERIADOS_FIJOS_NI = [
  "01-01", // Año Nuevo
  "01-18", // Rubén Darío
  "02-02", // Día de la Reconciliación y la Paz
  "02-21", // General Augusto C. Sandino
  "05-01", // Día del Trabajo
  "05-30", // Día de la Madre
  "07-19", // Revolución Sandinista
  "09-14", // Batalla de San Jacinto
  "09-15", // Independencia de Centroamérica
  "11-08", // Carlos Fonseca Amador
  "12-08", // Inmaculada Concepción
  "12-25"  // Navidad
];
function calcularPascua(anio) {
  const a = anio % 19;
  const b = Math.floor(anio / 100);
  const c = anio % 100;
  const d = Math.floor(b / 4);
  const e = b % 4;
  const f = Math.floor((b + 8) / 25);
  const g = Math.floor((b - f + 1) / 3);
  const h = (19 * a + b - d - g + 15) % 30;
  const i = Math.floor(c / 4);
  const k = c % 4;
  const l = (32 + 2 * e + 2 * i - h - k) % 7;
  const m = Math.floor((a + 11 * h + 22 * l) / 451);
  const mes = Math.floor((h + l - 7 * m + 114) / 31);
  const dia = ((h + l - 7 * m + 114) % 31) + 1;

  return new Date(anio, mes - 1, dia);
}

function esSemanaSanta(fecha) {
  const anio = fecha.getFullYear();
  const pascua = calcularPascua(anio);

  const juevesSanto = new Date(pascua);
  juevesSanto.setDate(pascua.getDate() - 3);

  const viernesSanto = new Date(pascua);
  viernesSanto.setDate(pascua.getDate() - 2);

  const sabadoSanto = new Date(pascua);
  sabadoSanto.setDate(pascua.getDate() - 1);

  return (
    fecha.toDateString() === juevesSanto.toDateString() ||
    fecha.toDateString() === viernesSanto.toDateString() ||
    fecha.toDateString() === sabadoSanto.toDateString()
  );
}

function esFeriadoNicaragua(fecha) {
  const mmdd =
    String(fecha.getMonth() + 1).padStart(2, "0") +
    "-" +
    String(fecha.getDate()).padStart(2, "0");

  return FERIADOS_FIJOS_NI.includes(mmdd) || esSemanaSanta(fecha);
}
function ajustarAFechaHabil(fecha) {
  while (true) {
    const esDomingo = fecha.getDay() === 0;
    const esFeriado = esFeriadoNicaragua(fecha);

    if (!esDomingo && !esFeriado) {
      return fecha;
    }

    // ➕ Avanza al siguiente día
    fecha.setDate(fecha.getDate() + 1);
  }
}
/*
====================================================
CREAR PRÉSTAMO
- Calcula el total
- Guarda el préstamo con usuario_id
- Luego llamará a generarCuotas
====================================================
*/
exports.crearPrestamo = (req, res) => {
  const { cliente_id, monto, interes, plazo, tipo_cuota } = req.body;

  // 🛑 Validaciones básicas
  if (!cliente_id || !monto || !interes || !plazo || !tipo_cuota) {
    return res.status(400).json({ mensaje: "Datos incompletos" });
  }

  // ✅ Usuario real logueado por JWT
  const usuario_id = req.usuario.id;

  // ✅ Cálculo del total (interés simple, una sola vez)
  const total = monto + (monto * (interes / 100));

  /*
    estado = 'activo'
    fecha_inicio = hoy
  */
  const sqlPrestamo = `
    INSERT INTO prestamos
      (
        cliente_id,
        usuario_id,
        monto,
        interes,
        total,
        plazo,
        tipo_cuota,
        fecha_inicio,
        estado
      )
    VALUES
      (?, ?, ?, ?, ?, ?, ?, CURDATE(), 'activo')
  `;

  db.query(
    sqlPrestamo,
    [
      cliente_id,
      usuario_id,
      monto,
      interes,
      total,
      plazo,
      tipo_cuota
    ],
    (err, result) => {
      if (err) {
        console.error("Error al crear préstamo:", err);
        return res.status(500).json({ mensaje: "Error al crear préstamo" });
      }

      // ✅ ID del préstamo recién creado
      const prestamoId = result.insertId;

      // 👉 PASAMOS al siguiente bloque
      // La lógica de días hábiles entra en generarCuotas
      generarCuotas(prestamoId, total, plazo, tipo_cuota, res);
    }
  );
};
/*
====================================================
GENERAR CUOTAS
- Respeta tipo de cuota
- NO genera domingos
- NO genera feriados (incluye Semana Santa)
- Ajusta automáticamente al siguiente día hábil
====================================================
*/
function generarCuotas(prestamoId, total, plazo, tipoCuota, res) {

  // 🔢 Número real de cuotas según tipo
  let numeroCuotas = plazo;

  if (tipoCuota === "diaria") numeroCuotas = plazo * 30;
  if (tipoCuota === "semanal") numeroCuotas = plazo * 4;
  if (tipoCuota === "quincenal") numeroCuotas = plazo * 2;
  if (tipoCuota === "mensual") numeroCuotas = plazo;

  // 💰 Monto por cuota
  const montoCuota = total / numeroCuotas;

  // 📅 Fecha base inicial (hoy)
  let fechaBase = new Date();

  const cuotas = [];

  for (let i = 1; i <= numeroCuotas; i++) {

    let fechaPago = new Date(fechaBase);

    // ➕ Avanzar desde la última cuota
    if (tipoCuota === "diaria") {
      fechaPago.setDate(fechaPago.getDate() + 1);
    }

    if (tipoCuota === "semanal") {
      fechaPago.setDate(fechaPago.getDate() + 7);
    }

    if (tipoCuota === "quincenal") {
      fechaPago.setDate(fechaPago.getDate() + 15);
    }

    if (tipoCuota === "mensual") {
      fechaPago.setMonth(fechaPago.getMonth() + 1);
    }

    // ✅ Ajustar domingos y feriados (incluye Semana Santa)
    fechaPago = ajustarAFechaHabil(fechaPago);

    // ✅ Guardar cuota
    cuotas.push([
      prestamoId,
      i,
      fechaPago,
      montoCuota
    ]);

    // ✅ La próxima cuota parte desde aquí
    fechaBase = new Date(fechaPago);
  }

  // 🗃 Guardar todas las cuotas
  const sqlCuotas = `
    INSERT INTO cuotas
      (prestamo_id, numero, fecha_pago, monto)
    VALUES ?
  `;

  db.query(sqlCuotas, [cuotas], err => {
    if (err) {
      console.error("Error al generar cuotas:", err);
      return res.status(500).json({ mensaje: "Error al generar cuotas" });
    }

    res.json({
      mensaje: "Préstamo y cuotas creadas correctamente ✅"
    });
  });
}
/*
====================================================
OBTENER PRÉSTAMOS POR CLIENTE
====================================================
*/
exports.obtenerPrestamosPorCliente = (req, res) => {
  const { clienteId } = req.params;

  const sql = `
    SELECT
      id,
      monto,
      interes,
      total,
      plazo,
      tipo_cuota,
      fecha_inicio,
      estado
    FROM prestamos
    WHERE cliente_id = ?
    ORDER BY fecha_inicio DESC
  `;

  db.query(sql, [clienteId], (err, rows) => {
    if (err) {
      console.error("Error al obtener préstamos:", err);
      return res.status(500).json({ mensaje: "Error al obtener préstamos" });
    }

    res.json(rows);
  });
};
/*
====================================================
TOTAL PAGADO POR CLIENTE
====================================================
*/
exports.obtenerTotalPagadoPorCliente = (req, res) => {
  const { clienteId } = req.params;

  const sql = `
    SELECT IFNULL(SUM(c.pagado), 0) AS total_pagado
    FROM prestamos p
    JOIN cuotas c ON c.prestamo_id = p.id
    WHERE p.cliente_id = ?
  `;

  db.query(sql, [clienteId], (err, rows) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ mensaje: "Error al obtener total pagado" });
    }

    res.json(rows[0]);
  });
};

/*
====================================================
HISTORIAL DE PRÉSTAMOS FINALIZADOS
====================================================
*/
exports.obtenerHistorialPrestamos = (req, res) => {
  const { clienteId } = req.params;

  const sql = `
    SELECT *
    FROM prestamos
    WHERE cliente_id = ?
    AND estado = 'finalizado'
    ORDER BY fecha_inicio DESC
  `;

  db.query(sql, [clienteId], (err, rows) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ mensaje: "Error al obtener historial" });
    }

    res.json(rows);
  });
};
exports.obtenerResumenMoraCliente = async (req, res) => {
  const { clienteId } = req.params;

  try {
    // 1️⃣ Buscar el préstamo activo del cliente
    const [prestamos] = await db.promise().execute(
      "SELECT id FROM prestamos WHERE cliente_id = ? AND estado = 'activo'",
      [clienteId]
    );

    if (prestamos.length === 0) {
      return res.json({
        moroso: false,
        mora_total: 0,
        cuotas_atrasadas: 0
      });
    }

    const prestamoId = prestamos[0].id;

    // 2️⃣ Obtener cuotas del préstamo
    const [cuotas] = await db.promise().execute(
      "SELECT monto, fecha_pago, estado FROM cuotas WHERE prestamo_id = ?",
      [prestamoId]
    );

    let moraTotal = 0;
    let cuotasAtrasadas = 0;

    cuotas.forEach(cuota => {
      if (cuota.estado !== "pendiente") return;

      const moraInfo = require("../utils/mora.utils").calcularMoraCuota(cuota);

      if (moraInfo.estado === "atrasada") {
        moraTotal += moraInfo.mora;
        cuotasAtrasadas++;
      }
    });

    res.json({
      moroso: cuotasAtrasadas > 0,
      mora_total: Number(moraTotal.toFixed(2)),
      cuotas_atrasadas: cuotasAtrasadas
    });

  } catch (error) {
    console.error("Error resumen mora:", error);
    res.status(500).json({ mensaje: "Error al obtener resumen de mora" });
  }
};
exports.obtenerPrestamosCompletadosCliente = (req, res) => {
  const { clienteId } = req.params;

  const sql = `
    SELECT COUNT(*) AS prestamos_completados
    FROM prestamos
    WHERE cliente_id = ?
    AND estado = 'finalizado'
  `;

  db.query(sql, [clienteId], (err, rows) => {
    if (err) {
      console.error("Error obteniendo préstamos completados:", err);
      return res.status(500).json({ mensaje: "Error al obtener préstamos completados" });
    }

    res.json(rows[0]);
  });
};

//exports
module.exports = {
  ...module.exports,
  esFeriadoNicaragua
};

