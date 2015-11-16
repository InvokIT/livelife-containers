mongoose = require "mongoose"
dns = require "dns"
log = require("log4js").getLogger "mongo/db"
fs = require "fs"
createModelFacade = require "./modelFacadeFactory"
assert = require "assert"
_ = require "lodash"

mongoose.Promise = Promise

# Load models
schemaData = do ->
	schemaNames = (fileName[0...fileName.lastIndexOf('.')] for fileName in fs.readdirSync "#{__dirname}/schemas")

	r = {}

	for mn in schemaNames
		d = require "./schemas/#{mn}"
		r[mn] = d

	return r

createModelsOnConnection = (connection) ->
	r = {}
	for mn, md of schemaData
		r[mn] = connection.model mn, md.schema
		assert r[mn]
	return r

createFacades = (models) ->
	r = {}

	for sn, sd of schemaData
		model = models[sn]

		assert model

		{facadeExtensions} = sd

		facade = createModelFacade model, facadeExtensions

		r[sn] = facade

	return r

###
modelFacades = do ->
	modelNames = (fileName[0...fileName.lastIndexOf('.')] for fileName in fs.readdirSync "#{__dirname}/models")

	r = {}

	for mn in modelNames
		{model, facade} = require "./models/#{mn}"
		log.debug "require model: #{JSON.stringify(require "./models/#{mn}")}"
		log.debug "Loaded #{JSON.stringify(model)} with facade #{JSON.stringify(facade)}"

		facade = createModelFacade model, facade

		r[mn] = facade

	return r

createConnectionModelFacades = (connection) ->
	facades = {}

	for mn, mf of modelFacades
		log.debug "#{mn}: #{JSON.stringify(mf)}"

		facades[mn] = Object.create mf

		log.debug "New connection facade: #{JSON.stringify(facades[mn])}"

		facades[mn]._model = connection.model mn

	return facades
###

prepareDb = (hostname, replicaSet = "rs0") ->
	log.debug "Entering prepareDb"

	connect = ->
		return new Promise (resolve, reject) ->
			dns.lookup hostname, { family: 4, all: true }, (err, addresses) ->
				if err?
					log.error "DNS lookup for #{hostname} failed: #{err}"
					reject err
					return

				addresses = _.chain(addresses).map("address").uniq()

				log.info "Resolved #{hostname} to #{JSON.stringify(addresses)}."

				connString = "mongodb://#{addresses.join(',')}"

				if addresses.length > 1
					connString += "?replicaSet=#{replicaSet}"

				connection = mongoose.createConnection()

				connection.on "connecting", (args...) -> log.trace "Connecting to #{connString}."
				connection.on "connected", -> log.info "Connected to #{connString}."
				connection.on "open", -> log.trace "Opened connection to #{connString}."
				connection.on "disconnecting", -> log.trace "Disconnecting with #{connString}."
				connection.on "disconnected", -> log.trace "Disconnected with #{connString}."
				connection.on "close", -> log.trace "Closed connection to #{connString}."
				connection.on "reconnected", -> log.trace "Reconnected to #{connString}."
				connection.on "error", (err) -> log.error "Connection error: #{err}"
				connection.on "fullsetup", -> log.trace "Connected to all nodes in replica set #{replicaSet} on #{connString}."

				connString = "mongodb://#{addresses.join(',')}"

				if addresses.length > 1
					connString += "?replicaSet=#{replicaSet}"

				connection.open connString, (err) ->
					if (err)?
						log.error "Failed to open connection string #{connString}. #{err}"
						reject err
						return

					resolve connection

	return use: (useFacadesCallback) ->
			log.debug "Entering use"

			return connect().then (connection) ->
					models = createModelsOnConnection connection
					facades = createFacades models

					log.debug "models: #{JSON.stringify(Object.keys(models))}"
					log.debug "facades: #{JSON.stringify(Object.keys(facades))}"

					useFacadesCallback facades
					.then -> connection.close()

module.exports = prepareDb
