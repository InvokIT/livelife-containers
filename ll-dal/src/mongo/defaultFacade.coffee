_ = require "lodash"
log = require("log4js").getLogger "mongo/defaultFacade"

defaultQueryOptions = lean: true

module.exports =

	# Create and save
	create: (valueObjects...) ->
		log.trace "create(#{JSON.stringify(valueObjects)}"

		if valueObjects.length is 0
			throw new Error "Missing arguments."

		this._model.create (if valueObjects.length is 1 then valueObjects[0] else valueObjects)

	find: (id, propertiesToFind) ->
		log.trace "findById(#{id}, #{propertiesToFind})"

		args = [id, cb]
		args.splice 1, 0, propertiesToFind if propertiesToFind?

		this._model.findById.apply this._model, args
		.exec()
		.catch (err) ->
			log.error "findById(#{id}, #{propertiesToFind}): #{err}"


	save: (documents...) ->
		throw new Error "Not implemented."

		log.trace "save(#{JSON.stringify(documents)}"

		this._model.update 

		insertDocs = []
		updateDocs = []

		for d in documents
			if d._id? then updateDocs.push d else insertDocs.push d

		queries = []
		# Update
		for document in updateDocs
			queries.push this._model.update(_id: document._id, document).exec()

		# Insert
		if insertDocs.length > 0
			queries.push this._model.create(insertDocs).exec().then (savedDocs) ->
				for d, i in documents
					sd = savedDocs[i].toJSON()
					d[mn] = sd[mn] for mn of sd
				return savedDocs

		Promise.all queries

	remove: (documents...) ->
		throw new Error "Not implemented."
		this.removeById _.map(documents, "_id")

	removeById: (ids...) ->
		throw new Error "Not implemented."
		this._model.remove _id: $in: ids
		.exec()

###
		update: (conditions, doc) ->
			log.debug "Entering update(#{JSON.stringify(conditions)}, #{JSON.stringify(doc)})"

			return new Promise (resolve, reject) ->
				this._model.update conditions, doc, (err) ->
					if err?
						log.error "Error updating: #{err}\nConditions: #{JSON.stringify(conditions)}\nDocument: #{JSON.stringify(doc)}"
						reject err
					else
						resolve()

		find: (conditions, propertiesToFind) ->
			log.debug "Entering find(#{JSON.stringify(conditions)})"

			return new Promise (resolve, reject) ->
				cb = (err, docs) ->
					if err?
						log.error "Error in find(#{JSON.stringify(conditions)}, #{JSON.stringify(propertiesToFind)})"
						reject err
					else
						resolve docs

				args = [conditions, defaultQueryOptions, cb]
				args.splice 1, 0, propertiesToFind if propertiesToFind?

				this._model.find.apply this._model, args
###
