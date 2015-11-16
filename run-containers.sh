#!/bin/sh

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker run --name mongodb -d -p 27017:27017 mongo:3.2 mongod

${DIR}/rtmp-controller/run.sh
${DIR}/rtmp/run.sh

read -n1 -r -p "Press any key to discard containers..."

docker kill rtmp && docker rm rtmp
docker kill rtmp-controller && docker rm rtmp-controller
docker kill mongodb && docker rm mongodb
