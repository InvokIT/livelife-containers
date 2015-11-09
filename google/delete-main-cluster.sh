#!/bin/sh
exec gcloud container --project "steady-cat-112112" clusters delete \
"main-cluster" \
--zone "europe-west1-b"