#!/bin/bash
set -e

FORMAT=$1
RTMPSERVER=$2
STREAM=$3
DEST_PREFIX=$4

case "$FORMAT" in
	hls )
		exec /usr/local/bin/transcode-hls.sh $RTMPSERVER $STREAM $DEST_PREFIX
		;;
	dash ) # Not implemented
		exec /usr/local/bin/transcode-dash.sh $RTMPSERVER $STREAM $DEST_PREFIX
		;;
esac
