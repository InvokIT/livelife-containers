#!/bin/bash

while true
do
	echo ${MONITOR_TOKEN_VALUE} | curl -T - -H "X-TTL:${MONITOR_TOKEN_TTL}" ${MONITOR_TOKEN_URL}
	sleep $(expr ${MONITOR_TOKEN_TTL} - 1)
done