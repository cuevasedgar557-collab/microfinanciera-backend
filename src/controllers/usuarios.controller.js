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

exports.editarUsuario = async (req, res) => {

  const id = req.params.id;

  if (Number(id) === req.usuario.id) {

    return res.status(400).json({
      mensaje:
        "No puedes editar tu propio usuario"
    });

  }

  const {
    nombre,
    usuario,
    password,
    rol_id
  } = req.body;

  if (req.usuario.rol !== "administrador") {
    return res.status(403).json({
      mensaje: "No autorizado"
    });
  }

  if (!nombre || !usuario || !rol_id) {
    return res.status(400).json({
      mensaje: "Datos incompletos"
    });
  }

  try {

    if (password && password.trim() !== "") {

      const password_hash =
        await bcrypt.hash(password, 10);

      const sql = `
        UPDATE usuarios
        SET
          nombre = ?,
          usuario = ?,
          password_hash = ?,
          rol_id = ?
        WHERE id = ?
      `;

      db.query(
        sql,
        [
          nombre,
          usuario,
          password_hash,
          rol_id,
          id
        ],
        err => {

          if (err) {
            console.error(err);

            return res.status(500).json({
              mensaje: "Error actualizando usuario"
            });
          }

          res.json({
            mensaje:
              "Usuario actualizado ✅"
          });

        }
      );

    } else {

      const sql = `
        UPDATE usuarios
        SET
          nombre = ?,
          usuario = ?,
          rol_id = ?
        WHERE id = ?
      `;

      db.query(
        sql,
        [
          nombre,
          usuario,
          rol_id,
          id
        ],
        err => {

          if (err) {
            console.error(err);

            return res.status(500).json({
              mensaje: "Error actualizando usuario"
            });
          }

          res.json({
            mensaje:
              "Usuario actualizado ✅"
          });

        }
      );

    }

  } catch (error) {

    console.error(error);

    res.status(500).json({
      mensaje: "Error interno"
    });

  }

};