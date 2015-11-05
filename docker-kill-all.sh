#!/bin/sh
exec docker kill $(docker ps -q)