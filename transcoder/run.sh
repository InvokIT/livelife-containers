#!/bin/bash
set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker build -t qvazar/transcoder ${DIR} && docker run --rm --volumes-from transcoder-sink qvazar/transcoder "$@"