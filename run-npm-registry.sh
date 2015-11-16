#!/bin/sh

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

exec docker run -d -p 4873:4873 -v ${DIR}/sinopia-config.yaml:/opt/sinopia/config.yaml keyvanfatehi/sinopia:latest