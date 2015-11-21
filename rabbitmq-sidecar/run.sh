#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker build -t qvazar/rabbitmq ${DIR}
docker run -p 5672:5672 -p 4369:4369 -p 25672:25672 -p 15672:15672 qvazar/rabbitmq