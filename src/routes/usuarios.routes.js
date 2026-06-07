const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth");
const usuariosController = require("../controllers/usuarios.controller");

router.post("/", auth, usuariosController.crearUsuario);
router.get("/", auth, usuariosController.listarUsuarios);

module.exports = router;