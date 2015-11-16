#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )

REGISTRY_CONTAINERID=$(docker run -d -p 4873:4873 keyvanfatehi/sinopia:latest)

NPM_REGISTRY="http://localhost:4873"
DOCKER_REGISTRY="eu.gcr.io/steady-cat-112112"

NPM_PKGS=("ll-dal")
CONTAINERS=("rtmp" "mongo-k8s-sidecar")
#UNITS=("rtmp" "transcoder" "transcoder-nfs-server")

for i in "${NPM_PKGS[@]}"
do
	echo Publishing package $i...
	cd ${DIR}/$i
	npm run build || true
	npm_config_registry=${NPM_REGISTRY} npm publish
	cd ${DIR}
done

for i in "${CONTAINERS[@]}"
do
	echo Building image ${DOCKER_REGISTRY}/${i}...
	docker build -t ${DOCKER_REGISTRY}/${i} ${DIR}/${i}/
	echo Done building image ${DOCKER_REGISTRY}/${i}
done

docker kill ${REGISTRY_CONTAINERID} && docker rm ${REGISTRY_CONTAINERID}

for i in "${CONTAINERS[@]}"
do
	echo Pushing image ${DOCKER_REGISTRY}/${i}...
	gcloud docker push ${DOCKER_REGISTRY}/${i}
	echo Done pushing image ${DOCKER_REGISTRY}/${i}
done