#!/bin/sh

set -e

gcloud compute --project "steady-cat-112112" disks create "mongo-1" --size "10" --zone "europe-west1-b" --type "pd-ssd"
gcloud compute --project "steady-cat-112112" disks create "mongo-2" --size "10" --zone "europe-west1-b" --type "pd-ssd"
gcloud compute --project "steady-cat-112112" disks create "mongo-3" --size "10" --zone "europe-west1-b" --type "pd-ssd"