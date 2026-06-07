const db = require("../config/db");

// ✅ Listar todos los barrios
const listarBarrios = (req, res) => {
  db.query(
    "SELECT id, nombre FROM barrios ORDER BY nombre",
    (err, rows) => {
      if (err) {
        console.error("Error listando barrios:", err);
        return res.status(500).json({ mensaje: "Error al listar barrios" });
      }
      res.json(rows);
    }
  );
};

// ✅ Crear un nuevo barrio
const crearBarrio = (req, res) => {
  const { nombre } = req.body;

  if (!nombre || !nombre.trim()) {
    return res.status(400).json({ mensaje: "El nombre es obligatorio" });
  }

  db.query(
    "INSERT INTO barrios (nombre) VALUES (?)",
    [nombre.trim()],
    err => {
      if (err) {
        console.error("Error creando barrio:", err);
        return res.status(500).json({ mensaje: "Error al crear barrio" });
      }
      res.json({ mensaje: "Barrio agregado ✅" });
    }
  );
};

// ✅ Obtener barrios por municipio (FILTRO CLAVE)
const obtenerBarriosPorMunicipio = (req, res) => {
  const { municipioId } = req.params;

  const sql = `
    SELECT id, nombre
    FROM barrios
    WHERE municipio_id = ?
    ORDER BY nombre
  `;

  db.query(sql, [municipioId], (err, rows) => {
    if (err) {
      console.error("Error al obtener barrios:", err);
      return res.status(500).json({ mensaje: "Error al obtener barrios" });
    }

    res.json(rows);
  });
};

// ✅ Eliminar barrio (solo admin)
const eliminarBarrio = (req, res) => {
  if (!req.usuario || req.usuario.rol !== "admin") {
    return res.status(403).json({ mensaje: "No autorizado" });
  }

  const { id } = req.params;

  db.query(
    "DELETE FROM barrios WHERE id = ?",
    [id],
    err => {
      if (err) {
        console.error("Error al eliminar barrio:", err);
        return res.status(500).json({ mensaje: "Error al eliminar barrio" });
      }

      res.json({ mensaje: "Barrio eliminado ✅" });
    }
  );
};

// ✅ EXPORTAR TODO JUNTO (CLAVE)
module.exports = {
  listarBarrios,
  crearBarrio,
  obtenerBarriosPorMunicipio,
  eliminarBarrio
};