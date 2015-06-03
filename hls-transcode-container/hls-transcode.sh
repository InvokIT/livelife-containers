#!/bin/bash
SRC=$1
DEST=$2
STREAMNAME=$3
AUDIO_BASEOPTIONS="-c:a libfdk_aac"
VIDEO_BASEOPTIONS="-c:v libx264 -preset ultrafast -profile:v baseline -g 40 -r 20"

exec /usr/local/bin/avconv -loglevel verbose -i ${SRC}/${STREAMNAME} \
$AUDIO_BASEOPTIONS -b:a 128k $VIDEO_BASEOPTIONS -b:v 512k -f flv ${DEST}/${STREAMNAME}_high \
$AUDIO_BASEOPTIONS -b:a 64k $VIDEO_BASEOPTIONS -b:v 256k -f flv ${DEST}/${STREAMNAME}_med \
$AUDIO_BASEOPTIONS -b:a 32k -ac 1 $VIDEO_BASEOPTIONS -b:v 128K -f flv ${DEST}/${STREAMNAME}_low