#!/bin/sh

CONTAINER_ID=$(docker run -d -P mongo:3.2 mongod)
MONGO_PORT=$(docker port $(CONTAINER_ID) | awk {'print $3'} | sed s/0.0.0.0://)

find test/ -name *-spec.coffee | xargs mocha --compilers coffee:coffee-script/register

docker kill $CONTAINER_ID
docker rm $CONTAINER_ID