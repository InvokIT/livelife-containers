#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )

#REGISTRY_CONTAINERID=$(${DIR}/run-npm-registry.sh)
#REGISTRY_ADDRESS=

#trap "{ docker kill ${REGISTRY_CONTAINERID} && docker rm ${REGISTRY_CONTAINERID}; }" EXIT

NPM_REGISTRY_IP=$(ip address show docker0 | grep -Eo '([[:digit:]]{1,3}.){3}[[:digit:]]{1,3}')
NPM_REGISTRY_PORT=4873 
NPM_REGISTRY="http://${NPM_REGISTRY_IP}:${NPM_REGISTRY_PORT}/"
DOCKER_REGISTRY="eu.gcr.io/steady-cat-112112"

NPM_PKGS=("ll-dal")
CONTAINERS=("rtmp" "rtmp-controller" "mongo-k8s-sidecar")
#UNITS=("rtmp" "transcoder" "transcoder-nfs-server")

for i in "${NPM_PKGS[@]}"
do
	echo Publishing package $i...
	cd ${DIR}/$i
	#npm_config_registry=${NPM_REGISTRY} npm publish
	npm publish
	cd ${DIR}
done

for i in "${CONTAINERS[@]}"
do
	echo Building image ${DOCKER_REGISTRY}/${i}...
	docker build --build-arg=NPM_CONFIG_REGISTRY=${NPM_REGISTRY} -t ${DOCKER_REGISTRY}/${i} ${DIR}/${i}/
	echo Done building image ${DOCKER_REGISTRY}/${i}
done

for i in "${CONTAINERS[@]}"
do
	echo Pushing image ${DOCKER_REGISTRY}/${i}...
	gcloud docker push ${DOCKER_REGISTRY}/${i}
	echo Done pushing image ${DOCKER_REGISTRY}/${i}
done