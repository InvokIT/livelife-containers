#!/bin/bash

cat /etc/nginx/nginx.conf | sed s/{{CTRLHOST}}/${RTMP_CTRL_ADDRESS}/ | tee /etc/nginx/nginx.conf

exec /usr/sbin/nginx "$@"