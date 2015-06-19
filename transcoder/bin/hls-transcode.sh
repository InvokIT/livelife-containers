#!/bin/bash
set -e

RTMPSERVER=$1
STREAM=$2
DEST_PATH=$HLS_OUT
DEST_PREFIX=$3
AUDIO_BASEOPTIONS="-c:a libfdk_aac"
VIDEO_BASEOPTIONS="-c:v libx264 -preset ultrafast -profile:v baseline -g 40 -r 20"
ENCODER_OPTIONS="-hls_time 2 -hls_list_size 10"

exec /usr/local/bin/avconv -loglevel warning -i ${RTMPSERVER}/${STREAM} \
$AUDIO_BASEOPTIONS -b:a 128k $VIDEO_BASEOPTIONS -b:v 512k $ENCODER_OPTIONS -f hls ${DEST_PATH}/${DEST_PREFIX}_${STREAM}_high.m3u8 \
$AUDIO_BASEOPTIONS -b:a 64k $VIDEO_BASEOPTIONS -b:v 256k $ENCODER_OPTIONS -f hls ${DEST_PATH}/${DEST_PREFIX}_${STREAM}_med.m3u8 \
$AUDIO_BASEOPTIONS -b:a 32k -ac 1 $VIDEO_BASEOPTIONS -b:v 128K $ENCODER_OPTIONS -f hls ${DEST_PATH}/${DEST_PREFIX}_${STREAM}_low.m3u8 \
&> ${LOG_PATH}