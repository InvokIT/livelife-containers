#!/bin/sh
set -e

INSTANCE=$1

gcloud compute instances attach-disk $INSTANCE --disk mongo-1 --device-name mongo-1
gcloud compute instances attach-disk $INSTANCE --disk mongo-2 --device-name mongo-2
gcloud compute instances attach-disk $INSTANCE --disk mongo-3 --device-name mongo-3