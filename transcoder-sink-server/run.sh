#!/bin/bash
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker run --rm --name transcoder-sink-server --volumes-from transcoder-sink -v ${DIR}/nginx.conf:/etc/nginx/nginx.conf:ro -p 8080:80 nginx:1