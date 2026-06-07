const db = require("../config/db");

// mysql2 en modo promise
const pool = db.promise();

// ✅ Importamos la función de mora
const { calcularMoraCuota } = require("../utils/mora.utils");

exports.obtenerCuotasPorPrestamo = async (req, res) => {
  try {
    const { prestamoId } = req.params;

    const [cuotas] = await pool.execute(`
      SELECT
        id,
        numero,
        fecha_pago,
        monto,
        pagado,
        estado
      FROM cuotas
      WHERE prestamo_id = ?
      ORDER BY numero
    `, [prestamoId]);

    // ✅ AQUÍ SE APLICA LA MORA A CADA CUOTA
    const cuotasConMora = cuotas.map(cuota => {
      const moraInfo = calcularMoraCuota(cuota);

      return {
        ...cuota,
        estado_mora: moraInfo.estado,
        dias_mora: moraInfo.dias_mora,
        mora: moraInfo.mora,
        total_pagar: moraInfo.total_pagar
      };
    });

    res.json(cuotasConMora);

  } catch (error) {
    console.error("❌ Error al obtener cuotas:", error);
    res.status(500).json({ mensaje: "Error al obtener cuotas" });
  }
};
