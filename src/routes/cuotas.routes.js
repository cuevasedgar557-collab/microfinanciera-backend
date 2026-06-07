const express = require("express");
const router = express.Router();
const auth = require("../middlewares/auth");
const cuotasController = require("../controllers/cuotas.controller");

// Obtener cuotas de un préstamo
router.get("/prestamo/:prestamoId", cuotasController.obtenerCuotasPorPrestamo);
router.post(
  "/:id/pago",
  auth,
  cuotasController.registrarPagoCuota
);


module.exports = router;