expect = require("chai").expect
db = require "../../src/mongo/db"

describe "db", ->

	beforeEach ->
		this.db = db -> Promise.resolve [process.env.MONGO_ADDRESS]

	it "should connect successfully to local test server", ->
		this.db.use (models) -> Promise.resolve()

	it "should fail connecting to nonexisting server", ->
		return new Promise (resolve, reject) ->
			db(-> Promise.resolve ["void"]).use (models) -> Promise.resolve()
				.catch -> resolve()
				.then -> reject()

