const express = require("express");
const router = express.Router();
const prestamosController = require("../controllers/prestamos.controller");

const auth = require("../middlewares/auth");

// ✅ Importar funciones explícitamente (NO el objeto completo)
const {
  crearPrestamo,
  crearPrestamoExistente,
  obtenerPrestamosPorCliente,
  obtenerTotalPagadoPorCliente,
  obtenerHistorialPrestamos
} = require("../controllers/prestamos.controller");

/*
=========================================
RUTAS DE PRÉSTAMOS (PROTEGIDAS)
=========================================
*/

// ✅ CREAR PRÉSTAMO
router.post("/", auth, crearPrestamo);
router.post("/existente", auth, crearPrestamoExistente);

// ✅ OBTENER PRÉSTAMOS POR CLIENTE
router.get("/cliente/:clienteId", auth, obtenerPrestamosPorCliente);

// ✅ TOTAL PAGADO POR CLIENTE
router.get(
  "/cliente/:clienteId/total-pagado",
  auth,
  obtenerTotalPagadoPorCliente
);

// ✅ HISTORIAL DE PRÉSTAMOS
router.get(
  "/cliente/:clienteId/historial",
  auth,
  obtenerHistorialPrestamos
);
// ✅ RESUMEN DE MORA POR CLIENTE
router.get(
  "/cliente/:clienteId/mora-resumen",
  auth,
  prestamosController.obtenerResumenMoraCliente
);
// ✅ PRÉSTAMOS COMPLETADOS POR CLIENTE
router.get(
  "/cliente/:clienteId/prestamos-completados",
  auth,
  prestamosController.obtenerPrestamosCompletadosCliente
);
``


module.exports = router;