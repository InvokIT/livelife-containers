#!/bin/sh

exec docker run --rm --link rtmp jedimonkey/avconv avconv -loglevel verbose -re \
-i http://content.bitsontherun.com/videos/nhYDGoyh-kNspJqnJ.mp4 \
-vcodec libx264 -vprofile baseline -acodec libmp3lame -ar 44100 \
-f flv rtmp://rtmp:1935/ingest/test
#http://content.bitsontherun.com/videos/nhYDGoyh-kNspJqnJ.mp4
