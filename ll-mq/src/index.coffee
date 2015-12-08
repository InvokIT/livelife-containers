MessageQueue = require "./MessageQueue"

options =
	server: "rabbitmq-stats-node" #TODO Find correct hostname

module.exports = new MessageQueue options