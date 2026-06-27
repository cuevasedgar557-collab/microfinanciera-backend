const db = require("../config/db");

const listarDepartamentos = (req, res) => {
  db.query(
    "SELECT id, nombre FROM departamentos ORDER BY nombre",
    (err, rows) => {
      if (err) {
        console.error("Error listando departamentos:", err);
        return res.status(500).json({ mensaje: "Error al listar departamentos" });
      }
      res.json(rows);
    }
  );
};

module.exports = {
  listarDepartamentos
};
