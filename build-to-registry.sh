#!/bin/bash

set -e

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
REGISTRY=$1

#docker run -d --name docker-registry -v ${DIR}/docker-registry/volume:/var/lib/registry -p 5000:5000 registry:2

UNITS=("rtmp")

for i in "${UNITS[@]}"
	docker build -t $(REGISTRY)/${i} ${DIR}/${i}/
	docker push $(REGISTRY)/${i}
done


#docker stop docker-registry
#docker rm docker-registry