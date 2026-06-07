const express = require("express");
const router = express.Router();
const trabajosController = require("../controllers/trabajos.controller");

// listar trabajos
router.get("/", trabajosController.listarTrabajos);

// crear trabajo
router.post("/", trabajosController.crearTrabajo);

module.exports = router;