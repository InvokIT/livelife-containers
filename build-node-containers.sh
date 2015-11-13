#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

docker run --name sinopia -d -p 4873:4873 keyvanfatehi/sinopia:latest

NPM_PKGS=("ll-cache")
CONTAINERS=("rtmp-controller")
REGISTRY=http://localhost:4873
#npm set registry http://localhost:4873

for i in "${NPM_PKGS[@]}"
do
	echo Publishing package $i...
	npm_config_registry=${REGISTRY} npm publish  ${DIR}/$i
done

for i in "${UNITS[@]}"
do
	echo Building image $i...
	docker build -t ${REGISTRY}/${i} ${DIR}/${i}/
	docker push ${REGISTRY}/${i}
	echo Done building image $i
done


#docker stop docker-registry
#docker rm docker-registry