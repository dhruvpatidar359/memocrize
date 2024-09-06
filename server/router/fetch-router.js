const express = require('express');
const router = express.Router();
const { fetchAllSubcollections } = require("../controller/fetchSnapshot-controller");

router.route("/snapshot").get(fetchAllSubcollections);

module.exports = router;