#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

exec docker start sinopia || docker run -d --name sinopia -p 4873:4873 -v ${DIR}/sinopia-config.yaml:/opt/sinopia/config.yaml keyvanfatehi/sinopia:latest