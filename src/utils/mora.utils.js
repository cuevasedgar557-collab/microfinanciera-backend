const { esFeriadoNicaragua } = require("../controllers/prestamos.controller");

function limpiarHora(fecha) {
  const f = new Date(fecha);
  f.setHours(0, 0, 0, 0);
  return f;
}

function calcularMoraCuota(cuota) {
  const montoBase = Number(cuota.monto);
  if (isNaN(montoBase)) {
    return {
      estado: "al_dia",
      dias_mora: 0,
      mora: 0,
      total_pagar: 0
    };
  }

  // ✅ FECHA FIJA PARA PRUEBA
  const hoy = limpiarHora("2026-06-04");

  const fechaVencimiento = limpiarHora(cuota.fecha_pago);

  // ✅ Si no ha vencido, no hay mora
  if (hoy <= fechaVencimiento) {
    return {
      estado: "al_dia",
      dias_mora: 0,
      mora: 0,
      total_pagar: montoBase
    };
  }

  // 🔢 CONTAR DÍAS DE MORA (DÍAS HÁBILES)
  let diasMora = 0;
  let cursor = new Date(fechaVencimiento);
  cursor.setDate(cursor.getDate() + 1);

  while (cursor <= hoy) {
    if (
      cursor.getDay() !== 0 &&               // no domingo
      !esFeriadoNicaragua(cursor)            // feriados existentes
    ) {
      diasMora++;
    }
    cursor.setDate(cursor.getDate() + 1);
  }

  // 🔥 MORA COMPUESTA DIARIA 2%
  let mora = 0;
  for (let i = 0; i < diasMora; i++) {
    mora += (montoBase + mora) * 0.02;
  }

  return {
    estado: "atrasada",
    dias_mora: diasMora,
    mora: Number(mora.toFixed(2)),
    total_pagar: Number((montoBase + mora).toFixed(2))
  };
}

module.exports = { calcularMoraCuota };
