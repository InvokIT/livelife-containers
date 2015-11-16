_ = require "lodash"
log = require("log4js").getLogger "mongo/defaultFacade"

defaultQueryOptions = lean: true

module.exports =

	create: (values) ->
		log.trace "create(#{JSON.stringify(values)}"
		Promise.resolve new this._model values

	findById: (id, propertiesToFind) ->
		log.trace "findById(#{id}, #{propertiesToFind})"

		args = [id, defaultQueryOptions, cb]
		args.splice 1, 0, propertiesToFind if propertiesToFind?

		this._model.findById.apply this._model, args
		.exec()
		.catch (err) ->
			log.error "findById(#{id}, #{propertiesToFind}): #{err}"

	save: (documents...) ->
		log.trace "save(#{JSON.stringify(documents)}"

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
		this.removeById _.map(documents, "_id")

	removeById: (ids...) ->
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
