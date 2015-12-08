child_process = require "child_process"
log = require("log4js").getLogger "rabbitmqctl"

DEFAULT_BINPATH = "/usr/lib/rabbitmq/bin/rabbitmqctl"

COMMANDS = [
	"stop_app"
	"start_app"
	"join_cluster"
	"forget_cluster_node"
	"update_cluster_nodes"
	"cluster_status"
	"wait"
]

class RabbitMqCtl
	constructor: (options) ->
		{@node, @binPath} = options

		@binPath ?= DEFAULT_BINPATH

	invoke: (params...) ->
		params.unshift "-n", @node if @node?

		params.unshift "-q"

		log.debug "Running command: #{@binPath} #{params.join(" ")}"
		return child_process.execFileSync @binPath, params, encoding: "utf8"

for cmd in COMMANDS
	do (cmd) -> RabbitMqCtl.prototype[cmd] = (params...) -> @invoke cmd, params...

module.exports = RabbitMqCtl