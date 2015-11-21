#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && cd .. && pwd )

#REGISTRY_CONTAINERID=$(${DIR}/run-npm-registry.sh)
#REGISTRY_ADDRESS=

#trap "{ docker kill ${REGISTRY_CONTAINERID} && docker rm ${REGISTRY_CONTAINERID}; }" EXIT

DOCKER_IP=$(ip -4 address show docker0 | grep -Eo '([[:digit:]]{1,3}.){3}[[:digit:]]{1,3}')
NPM_REGISTRY_PORT=4873 
NPM_REGISTRY="http://${DOCKER_IP}:${NPM_REGISTRY_PORT}/"
DOCKER_REGISTRY="eu.gcr.io/steady-cat-112112"

NPM_PKGS=("ll-k8s" "ll-dal")
CONTAINERS=("rtmp" "rtmp-controller" "mongo-k8s-sidecar" "transcoder-manager")
#UNITS=("rtmp" "transcoder" "transcoder-nfs-server")

for i in "${NPM_PKGS[@]}"
do
	echo Publishing package $i...
	cd ${DIR}/$i
	#npm_config_registry=${NPM_REGISTRY} npm publish
	npm publish || true
	cd ${DIR}
done

for i in "${CONTAINERS[@]}"
do
	echo Building image ${DOCKER_REGISTRY}/${i}...

	if grep -q "ARG NPM_CONFIG_REGISTRY" ${DIR}/${i}/Dockerfile; then
		docker build --build-arg=NPM_CONFIG_REGISTRY=${NPM_REGISTRY} -t ${DOCKER_REGISTRY}/${i} ${DIR}/${i}/
	else
		docker build -t ${DOCKER_REGISTRY}/${i} ${DIR}/${i}/
	fi

	echo Done building image ${DOCKER_REGISTRY}/${i}
done

for i in "${CONTAINERS[@]}"
do
	echo Pushing image ${DOCKER_REGISTRY}/${i}...
	gcloud docker push ${DOCKER_REGISTRY}/${i}
	echo Done pushing image ${DOCKER_REGISTRY}/${i}
done