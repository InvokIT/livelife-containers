#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker build -t qvazar/rtmp ${DIR} && docker run --rm --name rtmp -p 1935:1935 -p 8080:8080 qvazar/rtmp