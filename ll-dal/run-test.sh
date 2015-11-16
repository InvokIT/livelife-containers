#!/bin/sh

CONTAINER_ID=$(docker run -d -p 27017:27017 mongo:3.2 mongod)

find test/ -name *-spec.coffee | xargs mocha --compilers coffee:coffee-script/register

docker kill $CONTAINER_ID
docker rm $CONTAINER_ID