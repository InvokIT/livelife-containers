#!/bin/bash
mkdir -p /shared/{hls,dash,rec} || exit 1
exec /usr/sbin/nginx "$@"