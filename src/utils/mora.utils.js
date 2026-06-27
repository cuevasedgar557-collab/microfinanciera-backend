const { esFeriadoNicaragua } = require("../controllers/prestamos.controller");

// ===============================
// ✅ UTILIDAD: limpiar hora
// ===============================
function limpiarHora(fecha) {
  const f = new Date(fecha);
  f.setHours(0, 0, 0, 0);
  return f;
}

// ===============================
// 🔧 SIMULADOR DE FECHA (DESARROLLO)
// ===============================
// Para producción: poner null
const FECHA_SIMULADA = null;
// =================================================
// ✅ MORA INFORMATIVA (DÍAS DE ATRASO)
// =================================================
function calcularMoraCuota(cuota) {
  const hoy = limpiarHora(
    FECHA_SIMULADA ? new Date(FECHA_SIMULADA) : new Date()
  );

  const fechaVencimiento = limpiarHora(cuota.fecha_pago);

  if (hoy <= fechaVencimiento) {
    return { estado: "al_dia", dias_mora: 0 };
  }

  let diasMora = 0;
  let cursor = new Date(fechaVencimiento);
  cursor.setDate(cursor.getDate() + 1);

  while (cursor <= hoy) {
    if (cursor.getDay() !== 0 && !esFeriadoNicaragua(cursor)) {
      diasMora++;
    }
    cursor.setDate(cursor.getDate() + 1);
  }

  return { estado: "atrasada", dias_mora: diasMora };
}

// =================================================
// ✅ MORA MENSUAL (FIJA, UNA VEZ POR MES)
// =================================================

// ===============================
// ✅ EXPORTS
// ===============================
module.exports = {
  calcularMoraCuota,
};