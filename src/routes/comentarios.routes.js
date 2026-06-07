const express = require("express");
const router = express.Router();
const comentariosController = require("../controllers/comentarios.controller");

// crear comentario
router.post("/", comentariosController.crearComentario);

// obtener comentarios de un cliente
router.get("/:clienteId", comentariosController.obtenerComentarios);

module.exports = router;