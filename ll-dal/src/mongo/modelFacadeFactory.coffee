log = require("log4js").getLogger "mongo/modelFacadeFactory"
defaultFacadeLog = require("log4js").getLogger "mongo/modelFacadeFactory/defaultFacade"

defaultQueryOptions = lean: true

defaultFacade = require "./defaultFacade"

module.exports = (model, extensions) ->

	facade = Object.create defaultFacade
	facade._model = model

	facade[methodName] = method.bind(undefined, model) for methodName, method of extensions if extensions?

	return facade