mongoose = require "mongoose"
dns = require "dns"
log = require("log4js").getLogger "mongo/db"
fs = require "fs"
createModelFacade = require "./modelFacadeFactory"

# Load models
modelFacades = do ->
	modelNames = (fileName[0...fileName.lastIndexOf('.')] for fileName in fs.readdirSync "#{__dirname}/models")

	r = {}

	for mn in modelNames
		{model, facade} = require "./models/#{mn}"

		facade = createModelFacade model, facade

		r[mn] = facade

	return r

prepareDb = (hostname, replicaSet = "rs0") ->
	log.debug "Entering prepareDb"

	connect = ->
		return new Promise (resolve, reject) ->
			dns.lookup hostname, all: true, (err, addresses) ->
				if err?
					log.error "DNS lookup for #{hostname} failed: #{err}"
					reject err
					return

				log.trace "Resolved #{hostname} to #{JSON.stringify(addresses)}."

				addresses = (m.address for m in addresses)

				connection = mongoose.createConnection()

				connection.on "connecting", -> log.trace "Connecting to #{hostname}."
				connection.on "connected", -> log.trace "Connected to #{hostname}."
				connection.on "open", -> log.info "Opened connection to #{hostname}."
				connection.on "disconnecting", -> log.trace "Disconnecting with #{hostname}."
				connection.on "disconnected", -> log.trace "Disconnected with #{hostname}."
				connection.on "close", -> log.info "Closed connection to #{hostname}."
				connection.on "reconnected", -> log.info "Reconnected to #{hostname}."
				connection.on "error", (err) -> log.error "Connection error: #{err}"
				connection.on "fullsetup", -> log.trace "Connected to all nodes in replica set #{replicaSet} on #{hostname}."

				connString = "mongodb://#{addresses.join(',')}/"

				if addresses.length > 1
					connString += "?replicaSet=#{replicaSet}"

				connection.open connString, (err) ->
					if (err)?
						log.error "Failed to open connection string #{connString}. #{err}"
						reject err
						return

					resolve connection

	return use: (modelsCallback) ->
			log.debug "Entering use"

			return connect().then (connection) ->
					modelsCallback modelFacades
					.then connection.close()

module.exports = prepareDb
