const express = require("express");
const router = express.Router();

const auth = require("../middlewares/auth");
const barriosController = require("../controllers/barrios.controller");

router.get("/", auth, barriosController.listarBarrios);
router.post("/", auth, barriosController.crearBarrio);

router.get(
  "/municipio/:municipioId",
  auth,
  barriosController.obtenerBarriosPorMunicipio
);

router.delete(
  "/:id",
  auth,
  barriosController.eliminarBarrio
);

// ✅ ✅ ESTAS SON LAS NUEVAS BIEN HECHAS
router.get("/pendientes", auth, barriosController.obtenerBarriosPendientes);
router.put("/aprobar/:id", auth, barriosController.aprobarBarrio);
router.delete("/pendientes/:id", auth, barriosController.eliminarBarrioPendiente);

module.exports = router;