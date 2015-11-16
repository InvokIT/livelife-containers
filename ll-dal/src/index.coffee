serverHost = process.env.MONGO_HOST or "mongodb"

module.exports = require("./mongo/db")(serverHost)