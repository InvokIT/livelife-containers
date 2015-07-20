express = require "express"
router = express.Router()

logger = require("./log").getLogger "router"



module.exports = router