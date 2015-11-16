expect = require("chai").expect
db = require "../../src/mongo/db"

describe "db", ->

	it "should connect successfully to local test server", ->
		db("localhost").use (models) -> Promise.resolve()

	it "should fail connecting to nonexisting server", ->
		return new Promise (resolve, reject) ->
			db("nonexisting").use (models) -> Promise.resolve()
				.catch -> resolve()
				.then -> reject()

