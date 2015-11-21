#!/bin/sh

set -e

CONTAINER_ID=$(docker run -d -P rabbitmq:3.5-management)
RABBITMQ_ADDRESS=$(docker port ${CONTAINER_ID} | awk {'print $3'})

#MONGO_PORT=${MONGO_PORT} find test/ -name *-spec.coffee | xargs mocha --compilers coffee:coffee-script/register
RABBITMQ_ADDRESS=${RABBITMQ_ADDRESS} mocha --compilers coffee:coffee-script/register --recursive ./test/

docker kill $CONTAINER_ID
docker rm $CONTAINER_ID