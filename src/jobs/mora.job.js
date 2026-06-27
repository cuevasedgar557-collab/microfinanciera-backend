const cron = require("node-cron");
const { calcularMoraMensual } = require("../services/moraMensual.service");

// ⏰ Ejecutar mora automáticamente el día 1 de cada mes a la 1:00 AM
cron.schedule("0 1 1 * *", async () => {
  try {
    const fecha = new Date();
    fecha.setMonth(fecha.getMonth() - 1);

    const ciclo = fecha.toISOString().slice(0, 7);

    console.log("🚀 Ejecutando mora automática del ciclo:", ciclo);

    await calcularMoraMensual(ciclo);

    console.log("✅ Mora aplicada correctamente");
    
  } catch (error) {
    console.error("❌ Error ejecutando mora automática:", error);
  }
});
