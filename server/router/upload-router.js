const express = require('express');
const router = express.Router();
const uploadController = require("../controller/upload-controller");

router.route("/screenshot").post(uploadController.uploadImage);

router.route("/text").post(uploadController.uploadText);

module.exports = router;