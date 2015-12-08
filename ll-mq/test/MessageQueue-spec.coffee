expect = require("chai").expect
MQ = require "../src/MessageQueue"

define "MessageQueue", ->

	beforeEach ->
		@mq = new MQ server: process.env.MQ_ADDRESS

	define "send", ->
		it "should send a message on a queue", ->

		it "should reject an empty message", ->

	define "listen", ->
		it "should listen for messages", ->