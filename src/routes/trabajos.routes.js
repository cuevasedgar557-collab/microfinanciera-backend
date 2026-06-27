const express = require("express");
const router = express.Router();
const trabajosController = require("../controllers/trabajos.controller");
const auth = require("../middlewares/auth");

// listar trabajos
router.get("/", auth, trabajosController.listarTrabajos);

// crear trabajo
router.post("/", auth, trabajosController.crearTrabajo);

module.exports = router;