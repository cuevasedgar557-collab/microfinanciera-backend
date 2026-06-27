const express = require("express");
const router = express.Router();
const db = require("../config/db");
const auth = require("../middlewares/auth"); 

router.get("/:departamentoId",auth, (req, res) => {
  const { departamentoId } = req.params;

  db.query(
    "SELECT id, nombre FROM municipios WHERE departamento_id = ?",
    [departamentoId],
    (err, rows) => {
      if (err) return res.status(500).json(err);
      res.json(rows);
    }
  );
});

module.exports = router;