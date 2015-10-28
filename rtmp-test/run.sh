#!/bin/bash
set -e

HOST_IP=$( grep COREOS_PRIVATE_IPV4 /etc/environment | sed 's/COREOS_PRIVATE_IPV4=//')

exec docker run -e HOST_IP=$HOST_IP $HOST_IP:5000/rtmp-test