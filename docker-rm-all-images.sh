#!/bin/sh

exec docker rmi $(docker images -q)