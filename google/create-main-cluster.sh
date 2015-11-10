#!/bin/sh
exec gcloud container --project "steady-cat-112112" clusters create \
"main-cluster" \
--zone "europe-west1-b" \
--machine-type "n1-standard-1" \
--network "default" \
--enable-cloud-logging \
--enable-cloud-monitoring