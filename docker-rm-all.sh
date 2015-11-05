#!/bin/sh
exec docker rm $(docker ps -a -q)