#!/bin/sh

set -e

CONTAINER_ID=$(docker run -d -P rabbitmq:3.5)
MQ_ADDRESS=$(docker port ${CONTAINER_ID} | awk {'print $3'})

MQ_ADDRESS=${MQ_ADDRESS} mocha --compilers coffee:coffee-script/register --recursive ./test/

docker kill $CONTAINER_ID
docker rm $CONTAINER_ID