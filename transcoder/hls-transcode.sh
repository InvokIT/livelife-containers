#!/bin/bash
# CLI arguments:
# 1 Address to the origin RTMP server (rtmp://[x.x.x.x]/ingest)
# 2 The stream name (rtmp://x.x.x.x/ingest/[stream name])
# 3 The destination file prefix
# Uses the following environment variables:
# HLS_OUT Where to store HLS output files
# LOG_PATH where to log to
set -e

RTMPSERVER=$1
STREAM=$2
DEST_PATH=/sink/hls
DEST_PREFIX=$3
AUDIO_BASEOPTIONS="-c:a libfdk_aac"
VIDEO_BASEOPTIONS="-c:v libx264 -preset ultrafast -profile:v baseline -g 40 -r 20"
ENCODER_OPTIONS="-hls_time 2 -hls_list_size 10"
FILENAME=${STREAM}

sed s/{{STREAMNAME}}/${FILENAME}/ /etc/hls-index-template.m3u8 > ${DEST_PATH}/${FILENAME}.m3u8

COMMAND="/usr/local/bin/avconv -loglevel warning -i ${RTMPSERVER}/${STREAM} \
$AUDIO_BASEOPTIONS -b:a 128k $VIDEO_BASEOPTIONS -b:v 512k $ENCODER_OPTIONS -f hls ${DEST_PATH}/${FILENAME}_high.m3u8 \
$AUDIO_BASEOPTIONS -b:a 64k $VIDEO_BASEOPTIONS -b:v 256k $ENCODER_OPTIONS -f hls ${DEST_PATH}/${FILENAME}_med.m3u8 \
$AUDIO_BASEOPTIONS -b:a 32k -ac 1 $VIDEO_BASEOPTIONS -b:v 128K $ENCODER_OPTIONS -f hls ${DEST_PATH}/${FILENAME}_low.m3u8"

echo $COMMAND

exec $($COMMAND)