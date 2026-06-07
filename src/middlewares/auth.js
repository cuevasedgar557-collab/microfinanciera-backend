const jwt = require("jsonwebtoken");

const JWT_SECRET = "clave_super_secreta"; // luego va a .env

module.exports = (req, res, next) => {
  const authHeader = req.headers.authorization;

  // Header debe existir
  if (!authHeader) {
    return res.status(401).json({ mensaje: "Token no proporcionado" });
  }

  // Formato: Bearer TOKEN
  const token = authHeader.split(" ")[1];
  if (!token) {
    return res.status(401).json({ mensaje: "Token inválido" });
  }

  try {
    const decoded = jwt.verify(token, JWT_SECRET);
    req.usuario = decoded; // 👈 AQUÍ VIVE EL USUARIO
    next();
  } catch (err) {
    return res.status(401).json({ mensaje: "Token inválido o expirado" });
  }
};
