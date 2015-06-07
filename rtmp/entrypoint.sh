#!/bin/bash
exec /usr/sbin/nginx "$@" &2> /shared/logs/rtmp/nginx.log