const db = require("../config/db");

// crear comentario
exports.crearComentario = (req, res) => {
  const { cliente_id, comentario } = req.body;

  if (!comentario || !cliente_id) {
    return res.status(400).json({ mensaje: "Datos incompletos" });
  }

  const sql = `
    INSERT INTO comentarios_clientes (cliente_id, comentario)
    VALUES (?, ?)
  `;

  db.query(sql, [cliente_id, comentario], (err, result) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ mensaje: "Error al guardar comentario" });
    }

    res.json({ mensaje: "Comentario guardado ✅" });
  });
};

// listar comentarios por cliente
exports.obtenerComentarios = (req, res) => {
  const { clienteId } = req.params;

  const sql = `
    SELECT comentario, creado_en
    FROM comentarios_clientes
    WHERE cliente_id = ?
    ORDER BY creado_en DESC
  `;

  db.query(sql, [clienteId], (err, rows) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ mensaje: "Error al obtener comentarios" });
    }

    res.json(rows);
  });
};