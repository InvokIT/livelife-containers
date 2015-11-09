#!/bin/sh
exec gcloud container --project "steady-cat-112112" clusters create \
"main-cluster" \
--zone "europe-west1-b" \
--machine-type "g1-small" \
--network "default" \
--enable-cloud-logging \
--enable-cloud-monitoring