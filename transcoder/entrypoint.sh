#!/bin/bash
set -e

mkdir -p $(dirname $LOG_PATH) /sink/hls

RTMPSERVER=$1
STREAM=$2
DEST_PREFIX=$3

exec /usr/local/bin/hls-transcode.sh $RTMPSERVER $STREAM
