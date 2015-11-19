expect = require("chai").expect
prepareDb = require "../../src/mongo/db"
defaultFacadeProto = require "../../src/mongo/defaultFacade"

describe "defaultFacade", ->

	beforeEach ->
		this.db = prepareDb -> Promise.resolve [process.env.MONGO_ADDRESS]


	describe "create", ->
		it "should create a new model instance with the passed properties", ->
			this.db.use (facades) ->
				model = facades.TestSchema.create a: 1, b: 2, z: -1
				.then (model) ->
					expect(model).to.exist
					expect(model.a).to.be.equal 1
					expect(model.b).to.be.equal 2
					expect(model.z).to.be.equal -1

	describe "findById", ->
		it "should return the model with correct id"