const db = require("../config/db");
const pool = db.promise();

/*
=========================================
REGISTRAR PAGO DE UNA CUOTA
=========================================
*/
exports.registrarPago = async (req, res) => {
  try {
    const { cuota_id, monto } = req.body;

    console.log("🧪 BODY RECIBIDO:", req.body);

    // Validación básica
    if (!cuota_id || !monto || Number(monto) <= 0) {
      return res.status(400).json({ mensaje: "Datos inválidos" });
    }

    // 1️⃣ Buscar la cuota
    const [cuotas] = await pool.execute(
      "SELECT monto, pagado FROM cuotas WHERE id = ?",
      [cuota_id]
    );

    if (cuotas.length === 0) {
      return res.status(404).json({ mensaje: "Cuota no encontrada" });
    }

    const cuota = cuotas[0];

    const montoCuota = Number(cuota.monto);
    const pagadoActual = Number(cuota.pagado) || 0;
    const montoPago = Number(monto);

    const nuevoPagado = pagadoActual + montoPago;

    // 2️⃣ Evitar sobrepago
    if (nuevoPagado > montoCuota) {
      return res.status(400).json({
        mensaje: "El pago excede el monto de la cuota"
      });
    }

    const nuevoEstado =
      nuevoPagado >= montoCuota ? "pagada" : "pendiente";

    // 3️⃣ Actualizar cuota
    await pool.execute(
      "UPDATE cuotas SET pagado = ?, estado = ? WHERE id = ?",
      [nuevoPagado, nuevoEstado, cuota_id]
    );

    // 4️⃣ Cerrar préstamo si todas las cuotas están pagadas
    await pool.execute(`
      UPDATE prestamos
      SET estado = 'finalizado'
      WHERE id = (
        SELECT prestamo_id FROM cuotas WHERE id = ?
      )
      AND NOT EXISTS (
        SELECT 1 FROM cuotas
        WHERE prestamo_id = prestamos.id
        AND estado = 'pendiente'
      )
    `, [cuota_id]);

    console.log("✅ Pago registrado y préstamo verificado");

    res.json({ mensaje: "Pago registrado ✅" });

  } catch (error) {
    console.error("❌ ERROR registrarPago:", error);
    res.status(500).json({
      mensaje: "Error interno al registrar pago",
      error: error.message
    });
  }
};