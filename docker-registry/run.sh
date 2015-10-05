#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

/usr/bin/docker run --rm --name docker-registry -v ${DIR}/volume:/var/lib/registry -p 5000:5000 registry:2

#docker run --rm \
#-e REGISTRY_STORAGE_S3_ACCESSKEY=AKIAIM7UFCLSQX6IKIPA \
#-e REGISTRY_STORAGE_S3_REGION=eu-west-1 \
#-e REGISTRY_STORAGE_S3_V4AUTH=true \
#-e REGISTRY_STORAGE=s3 \
#-e REGISTRY_STORAGE_S3_BUCKET=livelife-docker-registry \
#-e REGISTRY_STORAGE_S3_SECRETKEY=pN0Q00jDB6YjMNV0sjxRID6YfLdfWorIjrylmoER \
#-p 5000:5000 \
#registry:2