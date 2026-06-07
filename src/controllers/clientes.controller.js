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
    trabajo_id
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
      usuario_id
    )
    VALUES (?,?,?,?,?,?,?,?,?,?)
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
      usuario_id
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
exports.eliminarCliente = (req, res) => {
  const { id } = req.params;

  const borrarCuotas = `
    DELETE FROM cuotas
    WHERE prestamo_id IN (
      SELECT id FROM prestamos WHERE cliente_id = ?
    )
  `;

  const borrarPrestamos = `
    DELETE FROM prestamos WHERE cliente_id = ?
  `;

  const borrarComentarios = `
    DELETE FROM comentarios_clientes WHERE cliente_id = ?
  `;

  const borrarCliente = `
    DELETE FROM clientes WHERE id = ?
  `;

  db.query(borrarCuotas, [id], err => {
    if (err) return res.status(500).json(err);

    db.query(borrarPrestamos, [id], err => {
      if (err) return res.status(500).json(err);

      db.query(borrarComentarios, [id], err => {
        if (err) return res.status(500).json(err);

        db.query(borrarCliente, [id], (err, result) => {
          if (err) return res.status(500).json(err);

          if (result.affectedRows === 0) {
            return res.status(404).json({ mensaje: "Cliente no encontrado" });
          }

          res.json({ mensaje: "Cliente eliminado correctamente ✅" });
        });
      });
    });
  });
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
    direccion
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
      direccion = ?
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