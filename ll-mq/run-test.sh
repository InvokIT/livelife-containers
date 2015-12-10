#!/bin/sh

CONTAINER_ID=$(docker run -d -P rabbitmq:3.5)
AMQ_ADDRESS="amqp://$(docker port ${CONTAINER_ID} | grep ^5672/tcp | awk {'print $3'})"

echo "Waiting for RabbitMQ to be ready..."
sleep 5s

echo AMQ_ADDRESS=${AMQ_ADDRESS}

AMQ_ADDRESS=${AMQ_ADDRESS} mocha --compilers coffee:coffee-script/register --recursive ./test/

docker kill $CONTAINER_ID
docker rm $CONTAINER_ID