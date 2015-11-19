#!/bin/sh

CONTAINER_ID=$(docker run -d -P mongo:3.2 mongod)
MONGO_ADDRESS=$(docker port ${CONTAINER_ID} | awk {'print $3'})

#MONGO_PORT=${MONGO_PORT} find test/ -name *-spec.coffee | xargs mocha --compilers coffee:coffee-script/register
MONGO_ADDRESS=${MONGO_ADDRESS} mocha --compilers coffee:coffee-script/register --recursive ./test/

docker kill $CONTAINER_ID
docker rm $CONTAINER_ID