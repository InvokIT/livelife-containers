#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker build -t qvazar/rtmp ${DIR} && docker run --rm -p 1935:1935 qvazar/rtmp