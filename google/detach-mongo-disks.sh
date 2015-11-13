#!/bin/sh
set -e

INSTANCE=$1

gcloud compute instances detach-disk $INSTANCE --disk mongo-1
gcloud compute instances detach-disk $INSTANCE --disk mongo-2
gcloud compute instances detach-disk $INSTANCE --disk mongo-3