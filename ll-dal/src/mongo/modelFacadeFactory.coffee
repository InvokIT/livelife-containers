log = require("log4js").getLogger "mongo/modelFacadeFactory"
defaultFacadeLog = require("log4js").getLogger "mongo/modelFacadeFactory/defaultFacade"

defaultQueryOptions = lean: true

defaultFacade =
	create: (values) ->
		defaultFacadeLog.debug "Entering create"
		new Promise (resolve, reject) ->
			resolve new this._model values

	findById: (id, propertiesToFind) ->
		defaultFacadeLog.debug "Entering findById"

		return new Promise (resolve, reject) ->
			cb = (err, doc) ->
				if err?
					defaultFacadeLog.error "findById error: #{err}"
					reject err
				else
					resolve doc

			args = if propertiesToFind? then [id, propertiesToFind, defaultQueryOptions, cb] else [id, defaultQueryOptions, cb]
			this._model.findById.apply this._model, args

	save: (documents...) ->
		defaultFacadeLog.trace "Entering save"

		insertDocs = []
		updateDocs = []

		for d in documents
			if d._id? then updateDocs.push d else insertDocs.push d

		return new Promise (resolve, reject) ->
			# Update
			for document in updateDocs
				this._model.update _id: document._id, document, (err) ->
					if err?
						defaultFacadeLog.error "Error updating documents #{JSON.stringify(documents)}: #{err}"
						reject err
			# Insert
			if insertDocs.length > 0
				this._model.create insertDocs, (err, savedDocs) ->
					if err?
						defaultFacadeLog.error "Error inserting documents #{JSON.stringify(documents)}: #{err}"
						reject err
					else
						for d, i in documents
							sd = savedDocs[i].toJSON()
							d[mn] = sd[mn] for mn of sd

			resolve()

###
		update: (conditions, doc) ->
			defaultFacadeLog.debug "Entering update(#{JSON.stringify(conditions)}, #{JSON.stringify(doc)})"

			return new Promise (resolve, reject) ->
				this._model.update conditions, doc, (err) ->
					if err?
						defaultFacadeLog.error "Error updating: #{err}\nConditions: #{JSON.stringify(conditions)}\nDocument: #{JSON.stringify(doc)}"
						reject err
					else
						resolve()

		find: (conditions, propertiesToFind) ->
			defaultFacadeLog.debug "Entering find(#{JSON.stringify(conditions)})"

			return new Promise (resolve, reject) ->
				cb = (err, docs) ->
					if err?
						defaultFacadeLog.error "Error in find(#{JSON.stringify(conditions)}, #{JSON.stringify(propertiesToFind)})"
						reject err
					else
						resolve docs

				args = [conditions, defaultQueryOptions, cb]
				args.splice 1, 0, propertiesToFind if propertiesToFind?

				this._model.find.apply this._model, args
###

module.exports = (model, extensions) ->

	facade = Object.create defaultFacade
	facade._model = model

	facade[methodName] = method.bind(undefined, model) for methodName, method of extensions if extensions?

	return facade