const db = require("../config/db");

const DIAS_CONSERVACION = 30;

// 🧹 Limpieza automática de recordatorios hechos
async function limpiarRecordatoriosHechos() {
  await db.promise().execute(
    `
    DELETE FROM recordatorios
    WHERE estado = 'hecho'
      AND fecha_hecho < DATE_SUB(CURDATE(), INTERVAL ? DAY)
    `,
    [DIAS_CONSERVACION]
  );
}

// ✅ Crear recordatorio
const crearRecordatorio = async (req, res) => {
  const { cliente_id, texto, fecha_recordatorio } = req.body;
  const usuario_id = req.usuario.id;

  try {
    await db.promise().execute(
      `
      INSERT INTO recordatorios
        (cliente_id, usuario_id, texto, fecha_recordatorio)
      VALUES (?, ?, ?, ?)
      `,
      [cliente_id, usuario_id, texto, fecha_recordatorio]
    );

    res.json({ mensaje: "Recordatorio creado ✅" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensaje: "Error al crear recordatorio" });
  }
};

// ✅ Recordatorios POR CLIENTE (ficha del cliente)
const obtenerRecordatoriosCliente = async (req, res) => {
  const { clienteId } = req.params;

  try {
    await limpiarRecordatoriosHechos();

    const [rows] = await db.promise().execute(
      `
      SELECT
        id,
        texto,
        fecha_recordatorio,
        fecha_creado,
        estado,
        fecha_hecho,
        DATEDIFF(
          DATE_ADD(fecha_hecho, INTERVAL 30 DAY),
          CURDATE()
        ) AS dias_restantes
      FROM recordatorios
      WHERE cliente_id = ?
      ORDER BY
        estado = 'pendiente' DESC,
        fecha_recordatorio ASC,
        fecha_hecho DESC
      `,
      [clienteId]
    );

    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensaje: "Error al obtener recordatorios del cliente" });
  }
};

// ✅ Recordatorios DEL DÍA (ficha central)
const obtenerRecordatoriosDelDia = async (req, res) => {
  try {
    await limpiarRecordatoriosHechos();

    const [rows] = await db.promise().execute(
      `
      SELECT
        r.id,
        r.texto,
        r.fecha_recordatorio,
        r.fecha_creado,
        c.nombre AS cliente
      FROM recordatorios r
      JOIN clientes c ON c.id = r.cliente_id
      WHERE r.estado = 'pendiente'
        AND r.fecha_recordatorio = CURDATE()
      ORDER BY r.fecha_creado DESC
      `
    );

    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensaje: "Error al obtener recordatorios del día" });
  }
};

// ✅ Marcar recordatorio como hecho
const marcarRecordatorioComoHecho = async (req, res) => {
  const { id } = req.params;

  try {
    await db.promise().execute(
      `
      UPDATE recordatorios
      SET estado = 'hecho',
          fecha_hecho = CURDATE()
      WHERE id = ?
      `,
      [id]
    );

    res.json({ mensaje: "Recordatorio marcado como hecho ✅" });
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensaje: "Error al marcar recordatorio como hecho" });
  }
};

// ✅ TODOS los acuerdos (ficha central)
const obtenerRecordatoriosTodos = async (req, res) => {
  try {
    await limpiarRecordatoriosHechos();

    const [rows] = await db.promise().execute(`
      SELECT
        r.id,
        r.texto,
        r.fecha_recordatorio,
        r.fecha_creado,
        r.estado,
        r.fecha_hecho,
        c.nombre AS cliente,
        CASE
          WHEN r.estado = 'hecho'
          THEN DATEDIFF(
            DATE_ADD(r.fecha_hecho, INTERVAL 30 DAY),
            CURDATE()
          )
          ELSE NULL
        END AS dias_restantes
      FROM recordatorios r
      JOIN clientes c ON c.id = r.cliente_id
      ORDER BY
        r.estado = 'pendiente' DESC,
        r.fecha_creado DESC
    `);

    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensaje: "Error al obtener todos los recordatorios" });
  }
};

// ✅ Recordatorios VENCIDOS (ficha central)
const obtenerRecordatoriosVencidos = async (req, res) => {
  try {
    const [rows] = await db.promise().execute(`
      SELECT
        r.id,
        r.texto,
        r.fecha_recordatorio,
        r.fecha_creado,
        c.nombre AS cliente
      FROM recordatorios r
      JOIN clientes c ON c.id = r.cliente_id
      WHERE r.estado = 'pendiente'
        AND r.fecha_recordatorio < CURDATE()
      ORDER BY r.fecha_recordatorio ASC
    `);

    res.json(rows);
  } catch (error) {
    console.error(error);
    res.status(500).json({ mensaje: "Error al obtener recordatorios vencidos" });
  }
};

// ✅ EXPORTS FINALES
module.exports = {
  crearRecordatorio,
  obtenerRecordatoriosCliente,
  obtenerRecordatoriosDelDia,
  obtenerRecordatoriosTodos,
  obtenerRecordatoriosVencidos,
  marcarRecordatorioComoHecho
};
