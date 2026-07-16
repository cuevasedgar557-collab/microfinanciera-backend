const express = require("express");

const router = express.Router();

const auth = require("../middlewares/auth");
const soloAdmin = require("../middlewares/soloAdmin");

const {
  enviarMensaje,
  obtenerMisNotificaciones,
  marcarLeido,
  confirmarMensaje,
  eliminarNotificacion,
  limpiarNotificacionesAtendidas,
  obtenerMensajesEnviados,
  obtenerDetalleMensaje
} = require("../controllers/mensajes.controller");

// Rutas de mensajes
router.post(
  "/",
  auth,
  soloAdmin,
  enviarMensaje
);

// Rutas de notificaciones
router.get(
  "/mis-notificaciones",
  auth,
  obtenerMisNotificaciones
);

// Ruta para marcar una notificación como leída
router.post(
  "/:id/leido",
  auth,
  marcarLeido
);

// Ruta para confirmar un mensaje
router.post(
  "/:id/confirmar",
  auth,
  confirmarMensaje
);

// ruta para eliminar una notificación
router.delete(
  "/:id",
  auth,
  eliminarNotificacion
);
// Ruta para limpiar notificaciones atendidas
router.delete(
  "/limpiar/atendidas",
  auth,
  limpiarNotificacionesAtendidas
);

// Ruta para obtener mensajes enviados
router.get(
  "/enviados",
  auth,
  soloAdmin,
  obtenerMensajesEnviados
);

// Ruta para obtener detalle de un mensaje
router.get(
  "/:id/detalle",
  auth,
  soloAdmin,
  obtenerDetalleMensaje
);


module.exports = router;