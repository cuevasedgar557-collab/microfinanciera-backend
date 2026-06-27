const express = require("express");
const router = express.Router();
const comentariosController = require("../controllers/comentarios.controller");
const auth = require("../middlewares/auth"); // ✅ AGREGAR
const { obtenerRecordatoriosHoy } = require("../controllers/recordatorios.controller");

// crear comentario
router.post("/", auth, comentariosController.crearComentario);

// obtener comentarios de un cliente
router.get("/:clienteId", auth, comentariosController.obtenerComentarios);

//recordatorio en el dashboard
router.get("/hoy", auth, obtenerRecordatoriosHoy);

module.exports = router;
