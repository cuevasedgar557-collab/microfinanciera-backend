const db = require("../config/db");

/**
 * GET /api/trabajos
 * Lista todos los trabajos
 */
exports.listarTrabajos = (req, res) => {
  db.query(
    "SELECT id, nombre FROM trabajos ORDER BY nombre",
    (err, rows) => {
      if (err) {
        console.error("Error listando trabajos:", err);
        return res.status(500).json({ mensaje: "Error al listar trabajos" });
      }
      res.json(rows);
    }
  );
};

/**
 * POST /api/trabajos
 * Crear un nuevo trabajo
 */
exports.crearTrabajo = (req, res) => {
  const { nombre } = req.body;

  if (!nombre || !nombre.trim()) {
    return res.status(400).json({ mensaje: "El nombre es obligatorio" });
  }

  db.query(
    "INSERT INTO trabajos (nombre) VALUES (?)",
    [nombre.trim()],
    err => {
      if (err) {
        console.error("Error creando trabajo:", err);
        return res.status(500).json({ mensaje: "Error al crear trabajo" });
      }
      res.json({ mensaje: "Trabajo agregado ✅" });
    }
  );
};