const db = require("../config/db");

/**
 * GET /api/clientes
 * Lista todos los clientes
 */
exports.listarClientes = (req, res) => {
  const usuario = req.usuario;

  let sql = `
    SELECT 
      c.id,
      c.nombre,
      c.cedula,
      c.sexo,
      c.telefono,
      c.estado_civil,
      d.nombre AS departamento,
      m.nombre AS municipio,
      b.nombre AS barrio,
      t.nombre AS trabajo,
      c.direccion
    FROM clientes c
    LEFT JOIN departamentos d ON c.departamento_id = d.id
    LEFT JOIN municipios m ON c.municipio_id = m.id
    LEFT JOIN barrios b ON c.barrio_id = b.id
    LEFT JOIN trabajos t ON c.trabajo_id = t.id
  `;

  const params = [];

  // ✅ Si NO es admin, solo sus clientes
  if (usuario.rol !== "administrador") {
    sql += " WHERE c.usuario_id = ?";
    params.push(usuario.id);
  }

  sql += " ORDER BY c.id DESC";

  db.query(sql, params, (error, rows) => {
    if (error) {
      console.error(error);
      return res.status(500).json({ mensaje: "Error al listar clientes" });
    }

    res.json(rows);
  });
};

/**
 * POST /api/clientes
 * Crear un cliente
 */

exports.crearCliente = (req, res) => {
  const {
    nombre,
    cedula,
    sexo,
    telefono,
    departamento_id,
    municipio_id,
    barrio_id,
    direccion,
    trabajo_id,
    estado_civil
  } = req.body;

  const usuario_id = req.usuario.id; // ✅ usuario real logueado

  const sql = `
  INSERT INTO clientes
  (
    nombre,
    cedula,
    sexo,
    telefono,
    departamento_id,
    municipio_id,
    barrio_id,
    direccion,
    trabajo_id,
    usuario_id,
    estado_civil
  )
  VALUES (?,?,?,?,?,?,?,?,?,?,?)
`;

  db.query(
    sql,
    [
      nombre,
      cedula,
      sexo,
      telefono,
      departamento_id,
      municipio_id,
      barrio_id,
      direccion,
      trabajo_id,
      usuario_id,
      estado_civil
    ],
    (error, result) => {
      if (error) {
        console.error(error);
        return res.status(500).json({ mensaje: "Error al crear cliente" });
      }

      res.json({
        mensaje: "Cliente creado correctamente ✅",
        clienteId: result.insertId
      });
    }
  );
};
``


/**
 * DELETE /api/clientes/:id
 * Eliminar cliente y dependencias
 */
const eliminarCliente = async (req, res) => {
  const { id } = req.params;
  const usuario = req.usuario;

  if (usuario.rol !== "administrador") {
    return res.status(403).json({
      mensaje: "No tienes permisos para eliminar clientes"
    });
  }

  const conn = await db.promise().getConnection();

  try {
    await conn.beginTransaction();

    // ✅ 1 eliminar cuotas
    await conn.execute(`
      DELETE c FROM cuotas c
      JOIN prestamos p ON c.prestamo_id = p.id
      WHERE p.cliente_id = ?
    `, [id]);

    // 🔥 2 eliminar FIADORES (ESTO ES LO QUE FALTABA)
    await conn.execute(`
      DELETE f FROM fiadores f
      JOIN prestamos p ON f.prestamo_id = p.id
      WHERE p.cliente_id = ?
    `, [id]);

    // ✅ 3 eliminar préstamos
    await conn.execute(`
      DELETE FROM prestamos 
      WHERE cliente_id = ?
    `, [id]);

    // ✅ 4 eliminar comentarios
    await conn.execute(`
      DELETE FROM comentarios_clientes
      WHERE cliente_id = ?
    `, [id]);

    // ✅ 5 eliminar recordatorios
    await conn.execute(`
      DELETE FROM recordatorios
      WHERE cliente_id = ?
    `, [id]);

    // ✅ 6 eliminar cliente
    await conn.execute(`
      DELETE FROM clientes
      WHERE id = ?
    `, [id]);

    await conn.commit();

    res.json({ mensaje: "Cliente eliminado correctamente ✅" });

  } catch (error) {
    await conn.rollback();

    console.error("Error eliminando cliente:", error);

    res.status(500).json({
      mensaje: "Error eliminando cliente"
    });

  } finally {
    conn.release();
  }
};

/**
 * GET /api/clientes/frecuentes
 */
exports.obtenerClientesFrecuentes = (req, res) => {
  const usuarioId = req.usuario.id;
  const rol = req.usuario.rol;

  let sql = `
    SELECT c.id, c.nombre, COUNT(p.id) AS prestamos_completados
    FROM clientes c
    JOIN prestamos p ON p.cliente_id = c.id
    WHERE p.estado = 'finalizado'
  `;

  const params = [];

  // 👷 si NO es admin, filtrar por el usuario
  if (rol !== "administrador") {
    sql += " AND c.usuario_id = ?";
    params.push(usuarioId);
  }

  sql += `
    GROUP BY c.id
    HAVING prestamos_completados >= 3
  `;

  db.query(sql, params, (err, rows) => {
    if (err) {
      return res.status(500).json({ mensaje: "Error" });
    }
    res.json(rows);
  });
};
exports.actualizarCliente = (req, res) => {
  const { id } = req.params;

  const {
  nombre,
  cedula,
  sexo,
  telefono,
  departamento_id,
  municipio_id,
  trabajo_id,
  barrio_id,
  direccion,
  estado_civil // ✅ AGREGAR
} = req.body;

  const sql = `
    UPDATE clientes
    SET
      nombre = ?,
      cedula = ?,
      sexo = ?,
      telefono = ?,
      departamento_id = ?,
      municipio_id = ?,
      trabajo_id = ?,
      barrio_id = ?,
      direccion = ?,
      estado_civil = ?
    WHERE id = ?
  `;

  db.query(
    sql,
    [
      nombre,
      cedula,
      sexo,
      telefono,
      departamento_id,
      municipio_id,
      trabajo_id,
      barrio_id,
      direccion,
      estado_civil,
      id
    ],
    err => {
      if (err) {
        console.error(err);
        return res.status(500).json({ mensaje: "Error al actualizar cliente" });
      }

      res.json({ mensaje: "Cliente actualizado ✅" });
    }
  );
};

const obtenerClientesDashboard = (req, res) => {
  const usuarioId = req.usuario.id;
  const rol = req.usuario.rol;

  // ✅ detectar admin correctamente
  const esAdmin = String(rol).toLowerCase() === "administrador";

  let sql = `
    SELECT 
      c.id,
      c.nombre,
      MAX(p.id) AS prestamo_id
    FROM clientes c
    LEFT JOIN prestamos p 
      ON p.cliente_id = c.id 
      AND p.estado = 'activo'
  `;

  let params = [];

  // ✅ SOLO filtrar si no es admin
  if (!esAdmin) {
    sql += " WHERE c.usuario_id = ?";
    params.push(usuarioId);
  }

  sql += `
    GROUP BY c.id, c.nombre
    ORDER BY c.nombre ASC
  `;

  db.query(sql, params, (err, rows) => {
    if (err) {
      console.error("❌ Error clientes dashboard:", err);
      return res.status(500).json(err);
    }

    res.json(rows);
  });
};


//exports
module.exports = {
  listarClientes: exports.listarClientes,
  crearCliente: exports.crearCliente,
  obtenerClientesFrecuentes: exports.obtenerClientesFrecuentes,
  actualizarCliente: exports.actualizarCliente,
  eliminarCliente,
  obtenerClientesDashboard
};