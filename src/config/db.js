const mysql = require("mysql2");

const db = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "", // XAMPP por defecto
  database: "microfinanciera",
  connectionLimit: 10
});

module.exports = db;