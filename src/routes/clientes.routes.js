const express = require("express");
const router = express.Router();

const clientesController = require("../controllers/clientes.controller");
const soloAdmin = require("../middlewares/soloAdmin");

const auth = require("../middlewares/auth");

router.get("/", auth, clientesController.listarClientes);
router.post("/", auth, clientesController.crearCliente);
router.delete("/:id", auth, clientesController.eliminarCliente);
router.get("/frecuentes", auth, clientesController.obtenerClientesFrecuentes);
router.put("/:id", auth, soloAdmin, clientesController.actualizarCliente);
router.get("/dashboard", auth, clientesController.obtenerClientesDashboard);
module.exports = router;