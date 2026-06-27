const db = require("../config/db");
const bcrypt = require("bcrypt");
const jwt = require("jsonwebtoken");

const JWT_SECRET = process.env.JWT_SECRET;
exports.login = (req, res) => {
  const { usuario, password } = req.body;

  if (!usuario || !password) {
    return res.status(400).json({ mensaje: "Datos incompletos" });
  }

  const sql = `
    SELECT u.*, r.nombre AS rol
    FROM usuarios u
    JOIN roles r ON r.id = u.rol_id
    WHERE u.usuario = ? AND u.activo = 1
  `;

  db.query(sql, [usuario], async (err, rows) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ mensaje: "Error interno" });
    }

    if (rows.length === 0) {
      return res.status(401).json({ mensaje: "Usuario no encontrado" });
    }

    const user = rows[0];

    const ok = await bcrypt.compare(password, user.password_hash);
    if (!ok) {
      return res.status(401).json({ mensaje: "Contraseña incorrecta" });
    }

    // ✅ Crear token
    const token = jwt.sign(
      {
        id: user.id,
        usuario: user.usuario,
        rol: user.rol,
        rol_id: user.rol_id
      },
      JWT_SECRET,
      { expiresIn: "8h" }
    );

    res.json({
      mensaje: "Login correcto ✅",
      token,
      usuario: {
        id: user.id,
        nombre: user.nombre,
        rol: user.rol
      }
    });
  });
};