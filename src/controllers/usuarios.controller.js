const db = require("../config/db");
const bcrypt = require("bcrypt");

exports.crearUsuario = async (req, res) => {
  const { nombre, usuario, password, rol_id } = req.body;

  // ✅ Solo admin
  if (req.usuario.rol !== "administrador") {
    return res.status(403).json({ mensaje: "No autorizado" });
  }

  if (!nombre || !usuario || !password || !rol_id) {
    return res.status(400).json({ mensaje: "Datos incompletos" });
  }

  const password_hash = await bcrypt.hash(password, 10);

  const sql = `
    INSERT INTO usuarios (nombre, usuario, password_hash, rol_id)
    VALUES (?, ?, ?, ?)
  `;

  db.query(sql, [nombre, usuario, password_hash, rol_id], (err) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ mensaje: "Error al crear usuario" });
    }

    res.json({ mensaje: "Usuario creado correctamente ✅" });
  });
};
``
exports.listarUsuarios = (req, res) => {
  if (req.usuario.rol !== "administrador") {
    return res.status(403).json({ mensaje: "No autorizado" });
  }

  const sql = `
    SELECT u.id, u.nombre, u.usuario, r.nombre AS rol, u.activo
    FROM usuarios u
    JOIN roles r ON r.id = u.rol_id
  `;

  db.query(sql, (err, rows) => {
    if (err) return res.status(500).json({ mensaje: "Error" });
    res.json(rows);
  });
};