#!/bin/bash
SRC=$1
DEST=$2
STREAMNAME=$3
AUDIO_BASEOPTIONS="-c:a libfdk_aac"
VIDEO_BASEOPTIONS="-c:v libx264 -preset ultrafast -profile:v baseline -g 40 -r 20"
OUT_OPTIONS="-hls_time 2 -hls_list_size 10 -hls_base_url ${TRANSCODE_BASEURL}"

# Uses the following env vars:
# TRANSCODE_IN The source stream or file
# TRANSCODE_OUT The target path to file (no extension!)

exec /usr/local/bin/avconv -loglevel verbose -i ${TRANSCODE_IN} \
$AUDIO_BASEOPTIONS -b:a 128k $VIDEO_BASEOPTIONS -b:v 512k ${TRANSCODE_OUT}_high.m3u8 \
$AUDIO_BASEOPTIONS -b:a 64k $VIDEO_BASEOPTIONS -b:v 256k ${TRANSCODE_OUT}_med.m3u8 \
$AUDIO_BASEOPTIONS -b:a 32k -ac 1 $VIDEO_BASEOPTIONS -b:v 128K ${TRANSCODE_OUT}_low.m3u8 \
2> /var/log/anconv/error.log 