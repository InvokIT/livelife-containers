FROM node:5.0
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

ENV COFFEE_VERSION=1.10.0

RUN npm install -g coffee-script@${COFFEE_VERSION}

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV NODE_ENV=production

ONBUILD COPY package.json /usr/src/app/
# Set NPM registry to the host ip and run npm install
ONBUILD RUN npm_config_registry=http://$(routel | grep -m 1 default | awk {'print $2'}):4873 npm install
ONBUILD COPY . /usr/src/app

ONBUILD ENTRYPOINT ["coffee", "main.coffee"]