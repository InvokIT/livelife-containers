#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )
REGISTRY="eu.gcr.io/steady-cat-112112"

UNITS=("rtmp")
#UNITS=("rtmp" "transcoder" "transcoder-nfs-server")

for i in "${UNITS[@]}"
do
	echo Building image ${REGISTRY}/${i}...
	docker build -t ${REGISTRY}/${i} ${DIR}/${i}/
	echo Done building image ${REGISTRY}/${i}

	echo Pushing image ${REGISTRY}/${i}...
	gcloud docker push ${REGISTRY}/${i}
	echo Done pushing image ${REGISTRY}/${i}
done
