const db = require("../config/db");

const enviarMensaje = (req, res) => {

  if (req.usuario.rol !== "administrador") {
    return res.status(403).json({
      mensaje: "No autorizado"
    });
  }

  const {
    titulo,
    mensaje,
    prioridad,
    paraTodos,
    usuario_id
  } = req.body;

  if (!titulo || !mensaje) {
    return res.status(400).json({
      mensaje: "Datos incompletos"
    });
  }

  const sqlMensaje = `
    INSERT INTO mensajes
    (
      usuario_origen,
      titulo,
      mensaje,
      prioridad
    )
    VALUES (?, ?, ?, ?)
  `;

  db.query(
    sqlMensaje,
    [
      req.usuario.id,
      titulo,
      mensaje,
      prioridad || "normal"
    ],
    (err, resultado) => {

      if (err) {
        console.error(err);

        return res.status(500).json({
          mensaje: "Error creando mensaje"
        });
      }

      const mensajeId = resultado.insertId;

      if (paraTodos) {

        db.query(
          `
          SELECT id
          FROM usuarios
          WHERE activo = 1
            AND rol_id = 2
          `,
          (err, usuarios) => {

            if (err) {
              console.error(err);

              return res.status(500).json({
                mensaje: "Error obteniendo usuarios"
              });
            }

            const valores = usuarios.map(u => [
              mensajeId,
              u.id
            ]);

            db.query(
              `
              INSERT INTO mensajes_destinatarios
              (
                mensaje_id,
                usuario_id
              )
              VALUES ?
              `,
              [valores],
              err => {

                if (err) {
                  console.error(err);

                  return res.status(500).json({
                    mensaje: "Error asignando destinatarios"
                  });
                }

                res.json({
                  mensaje:
                    "Mensaje enviado a todos ✅"
                });

              }
            );

          }
        );

      } else {

        db.query(
          `
          INSERT INTO mensajes_destinatarios
          (
            mensaje_id,
            usuario_id
          )
          VALUES (?, ?)
          `,
          [
            mensajeId,
            usuario_id
          ],
          err => {

            if (err) {
              console.error(err);

              return res.status(500).json({
                mensaje: "Error enviando mensaje"
              });
            }

            res.json({
              mensaje:
                "Mensaje enviado ✅"
            });

          }
        );

      }

    }
  );

};

const obtenerMisNotificaciones = (req, res) => {

  const sql = `
    SELECT
      md.id,

      m.titulo,
      m.mensaje,
      m.prioridad,
      m.fecha,

      u.nombre AS remitente,

      md.leido,
      md.confirmado

    FROM mensajes_destinatarios md

    INNER JOIN mensajes m
      ON m.id = md.mensaje_id

    INNER JOIN usuarios u
      ON u.id = m.usuario_origen

    WHERE md.usuario_id = ?
      AND md.oculto = 0

    ORDER BY m.fecha DESC
  `;

  db.query(
    sql,
    [req.usuario.id],
    (err, rows) => {

      if (err) {
        console.error(err);

        return res.status(500).json({
          mensaje: "Error obteniendo notificaciones"
        });
      }

      res.json(rows);

    }
  );

};


const marcarLeido = (req, res) => {

  const notificacionId = req.params.id;

  const sql = `
    UPDATE mensajes_destinatarios
    SET
      leido = 1,
      fecha_lectura = NOW()
    WHERE id = ?
      AND usuario_id = ?
  `;

  db.query(
    sql,
    [
      notificacionId,
      req.usuario.id
    ],
    (err, result) => {

      if (err) {
        console.error(err);

        return res.status(500).json({
          mensaje: "Error marcando lectura"
        });
      }

      res.json({
        mensaje: "Notificación leída ✅"
      });

    }
  );

};

const confirmarMensaje = (req, res) => {

  const notificacionId = req.params.id;

  const sql = `
    UPDATE mensajes_destinatarios
    SET
      confirmado = 1,
      fecha_confirmacion = NOW()
    WHERE id = ?
      AND usuario_id = ?
  `;

  db.query(
    sql,
    [
      notificacionId,
      req.usuario.id
    ],
    (err, result) => {

      if (err) {
        console.error(err);

        return res.status(500).json({
          mensaje: "Error confirmando mensaje"
        });
      }

      res.json({
        mensaje: "Mensaje confirmado ✅"
      });

    }
  );

};


const eliminarNotificacion = (req, res) => {

  const notificacionId = req.params.id;

  const sql = `
    UPDATE mensajes_destinatarios
    SET oculto = 1
    WHERE id = ?
      AND usuario_id = ?
  `;

  db.query(
    sql,
    [
      notificacionId,
      req.usuario.id
    ],
    (err) => {

      if (err) {

        console.error(err);

        return res.status(500).json({
          mensaje: "Error ocultando notificación"
        });

      }

      res.json({
        mensaje: "Notificación ocultada ✅"
      });

    }
  );

};

const limpiarNotificacionesAtendidas = (req, res) => {

  const sql = `
    UPDATE mensajes_destinatarios
    SET oculto = 1
    WHERE usuario_id = ?
      AND leido = 1
      AND confirmado = 1
      AND oculto = 0
  `;

  db.query(
    sql,
    [req.usuario.id],
    (err, result) => {

      if (err) {

        console.error(err);

        return res.status(500).json({
          mensaje: "Error limpiando notificaciones"
        });

      }

      res.json({
        mensaje:
          `${result.affectedRows} notificaciones ocultadas ✅`
      });

    }
  );

};

const obtenerMensajesEnviados = (req, res) => {

  const sql = `
    SELECT

      m.id,
      m.titulo,
      m.prioridad,
      m.fecha,

      DATEDIFF(
        DATE_ADD(m.fecha, INTERVAL 30 DAY),
        NOW()
      ) AS dias_restantes,

      COUNT(md.id) AS total,

      COALESCE(
        SUM(md.leido),
        0
      ) AS leidos,

      COALESCE(
        SUM(md.confirmado),
        0
      ) AS confirmados

    FROM mensajes m

    LEFT JOIN mensajes_destinatarios md
      ON md.mensaje_id = m.id

    WHERE m.usuario_origen = ?
      AND m.fecha >= DATE_SUB(
        NOW(),
        INTERVAL 30 DAY
      )

    GROUP BY
      m.id,
      m.titulo,
      m.prioridad,
      m.fecha

    ORDER BY m.fecha DESC
  `;

  db.query(
    sql,
    [req.usuario.id],
    (err, rows) => {

      if (err) {

        console.error(err);

        return res.status(500).json({
          mensaje: "Error obteniendo mensajes"
        });

      }

      res.json(rows);

    }
  );

};


const obtenerDetalleMensaje = (req, res) => {

  const mensajeId = req.params.id;

  const sql = `
    SELECT

      u.nombre,

      md.leido,
      md.confirmado,

      md.fecha_lectura,
      md.fecha_confirmacion

    FROM mensajes_destinatarios md

    INNER JOIN usuarios u
      ON u.id = md.usuario_id

    WHERE md.mensaje_id = ?

    ORDER BY u.nombre
  `;

  db.query(
    sql,
    [mensajeId],
    (err, rows) => {

      if (err) {
        console.error(err);

        return res.status(500).json({
          mensaje:
            "Error obteniendo detalle"
        });
      }

      res.json(rows);

    }
  );

};

const limpiarMensajesVencidos = () => {

  const sql1 = `
    DELETE md
    FROM mensajes_destinatarios md
    INNER JOIN mensajes m
      ON m.id = md.mensaje_id
    WHERE m.fecha <
      DATE_SUB(
        NOW(),
        INTERVAL 30 DAY
      )
  `;

  db.query(sql1, err => {

    if (err) {
      console.error(err);
      return;
    }

    const sql2 = `
      DELETE
      FROM mensajes
      WHERE fecha <
        DATE_SUB(
          NOW(),
          INTERVAL 30 DAY
        )
    `;

    db.query(sql2, err => {

      if (err) {
        console.error(err);
      }

    });

  });

};

module.exports = {
    enviarMensaje,
    obtenerMisNotificaciones,
    marcarLeido,
    confirmarMensaje,
    eliminarNotificacion,
    limpiarNotificacionesAtendidas,
    obtenerMensajesEnviados,
    obtenerDetalleMensaje
};