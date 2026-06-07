const express = require("express");
const cors = require("cors");

const clientesRoutes = require("./routes/clientes.routes");

const municipiosRoutes = require("./routes/municipios.routes");
const trabajosRoutes = require("./routes/trabajos.routes");
const comentariosRoutes = require("./routes/comentarios.routes");
const prestamosRoutes = require("./routes/prestamos.routes");
const cuotasRoutes = require("./routes/cuotas.routes");
const pagosRoutes = require("./routes/pagos.routes");
const barriosRoutes = require("./routes/barrios.routes");
const authRoutes = require("./routes/auth.routes");
const usuariosRoutes = require("./routes/usuarios.routes");
const recordatoriosRoutes = require("./routes/recordatorios.routes");
const departamentosRoutes = require("./routes/departamentos.routes");

const app = express();

// Middlewares globales
app.use(cors());
app.use(express.json());

// Rutas
app.use("/api/clientes", clientesRoutes);
app.use("/api/prestamos", prestamosRoutes);
app.use("/api/municipios", municipiosRoutes);
app.use("/api/trabajos", trabajosRoutes);
app.use("/api/comentarios", comentariosRoutes);
app.use("/api/cuotas", cuotasRoutes);
app.use("/api/pagos", pagosRoutes);
app.use("/api/barrios", barriosRoutes);
app.use("/api/auth", authRoutes);
app.use("/api/usuarios", usuariosRoutes);
app.use("/api/recordatorios", recordatoriosRoutes);
app.use("/api/departamentos", departamentosRoutes);


// Ruta de prueba
app.get("/", (req, res) => {
  res.send("✅ API Microfinanciera activa");
});

module.exports = app;