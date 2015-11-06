#!/bin/bash
docker create -v /sink --name transcoder-sink ubuntu:14.04 /bin/true