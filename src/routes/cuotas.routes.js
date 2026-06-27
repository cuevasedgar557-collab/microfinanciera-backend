const express = require("express");
const router = express.Router();

const auth = require("../middlewares/auth");
const cuotasController = require("../controllers/cuotas.controller");

router.get(
  "/prestamo/:prestamoId",
  cuotasController.obtenerCuotasPorPrestamo
);
router.get("/cobros-hoy", auth, cuotasController.obtenerCobrosHoy);
router.get("/pagos-hoy", auth, cuotasController.obtenerPagosHoy);
router.get("/meta-hoy", auth, cuotasController.obtenerMetaHoy);
router.get("/metas-anteriores", auth, cuotasController.obtenerMetasAnteriores);

router.post(
  "/:id/pago",
  auth,
  cuotasController.registrarPagoCuota
);

module.exports = router;