#!/bin/bash
mkdir -p /shared/{hls,dash,rec,logs/rtmp} || exit 1
exec /usr/sbin/nginx "$@" 2>> /shared/logs/rtmp/nginx.log