const express = require("express");
const router = express.Router();

const auth = require("../middlewares/auth");
const departamentosController = require("../controllers/departamentos.controller");

router.get("/", auth, departamentosController.listarDepartamentos);

module.exports = router;
