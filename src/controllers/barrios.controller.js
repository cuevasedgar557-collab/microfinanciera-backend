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
  const { nombre, municipio_id } = req.body;
  const usuario = req.usuario;

  // ✅ VALIDACIONES
  if (!nombre || !nombre.trim()) {
    return res.status(400).json({ mensaje: "El nombre es obligatorio" });
  }

  if (!municipio_id) {
    return res.status(400).json({ mensaje: "Debe seleccionar municipio" });
  }

  const nombreLimpio = nombre.trim();

  // ✅ 1. VERIFICAR SI YA EXISTE
  db.query(
    "SELECT id FROM barrios WHERE LOWER(nombre) = LOWER(?) AND municipio_id = ?",
    [nombreLimpio, municipio_id],
    (err, results) => {
      if (err) {
        console.error(err);
        return res.status(500).json({ mensaje: "Error verificando barrio" });
      }

      if (results.length > 0) {
        return res.status(400).json({
          mensaje: "Este barrio ya existe en ese municipio ❌"
        });
      }

      // ✅ 2. DEFINIR ESTADO SEGÚN ROL
      let estado = "pendiente";

      if (usuario.rol === "administrador") {
        estado = "activo";
      }

      // ✅ 3. INSERTAR
      db.query(
        "INSERT INTO barrios (nombre, municipio_id, estado) VALUES (?, ?, ?)",
        [nombreLimpio, municipio_id, estado],
        (err, result) => {
          if (err) {
            console.error(err);
            return res.status(500).json({ mensaje: "Error al crear barrio" });
          }

          res.json({
            id: result.insertId,
            estado,
            mensaje:
              estado === "pendiente"
                ? "Barrio enviado para aprobación ✅"
                : "Barrio creado ✅"
          });
        }
      );
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
    AND estado = 'activo'  
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
  if (!req.usuario || req.usuario.rol !== "administrador") {
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

//barrios pendientes
const obtenerBarriosPendientes = (req, res) => {
  const sql = `
    SELECT id, nombre
    FROM barrios
    WHERE estado = 'pendiente'
    ORDER BY nombre
  `;

  db.query(sql, (err, rows) => {
    if (err) {
      console.error("Error obteniendo pendientes:", err);
      return res.status(500).json({ mensaje: "Error" });
    }

    res.json(rows);
  });
};

//aprobar barrios solo admin
const aprobarBarrio = (req, res) => {
  if (req.usuario.rol !== "administrador") {
    return res.status(403).json({ mensaje: "No autorizado" });
  }

  const { id } = req.params;

  const sql = `
    UPDATE barrios
    SET estado = 'activo'
    WHERE id = ?
  `;

  db.query(sql, [id], err => {
    if (err) {
      console.error("Error aprobando barrio:", err);
      return res.status(500).json({ mensaje: "Error" });
    }

    res.json({ mensaje: "Barrio aprobado ✅" });
  });
};
//eliminar barrio pendiente
const eliminarBarrioPendiente = (req, res) => {
  const { id } = req.params;

  db.query(
    "DELETE FROM barrios WHERE id = ? AND estado = 'pendiente'",
    [id],
    err => {
      if (err) {
        console.error("Error eliminando:", err);
        return res.status(500).json({ mensaje: "Error" });
      }

      res.json({ mensaje: "Barrio eliminado ❌" });
    }
  );
};
// ✅ EXPORTAR TODO JUNTO (CLAVE)
module.exports = {
  listarBarrios,
  crearBarrio,
  obtenerBarriosPorMunicipio,
  eliminarBarrio,
  obtenerBarriosPendientes,
  aprobarBarrio,
  eliminarBarrioPendiente
};