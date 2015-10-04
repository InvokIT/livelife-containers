#!/bin/bash

while true
do
	echo ${HEARTBEAT_TOKEN_VALUE} | curl -T - -H "X-TTL:${HEARTBEAT_TOKEN_TTL}" ${HEARTBEAT_TOKEN_URL}
	sleep $(expr ${HEARTBEAT_TOKEN_TTL} - 1)
done