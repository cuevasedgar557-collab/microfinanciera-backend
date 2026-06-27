const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth");
const recordatoriosController = require("../controllers/recordatorios.controller");

router.post("/", auth, recordatoriosController.crearRecordatorio);
router.get(
  "/cliente/:clienteId",
  auth,
  recordatoriosController.obtenerRecordatoriosCliente
);
router.get(
  "/hoy",
  auth,
  recordatoriosController.obtenerRecordatoriosDelDia
);
router.put(
  "/:id/hecho",
  auth,
  recordatoriosController.marcarRecordatorioComoHecho
);
router.get(
  "/todos",
  auth,
  recordatoriosController.obtenerRecordatoriosTodos
);

router.get(
  "/vencidos",
  auth,
  recordatoriosController.obtenerRecordatoriosVencidos
);

router.get("/hoy", auth, recordatoriosController.obtenerRecordatoriosHoy);

module.exports = router;
