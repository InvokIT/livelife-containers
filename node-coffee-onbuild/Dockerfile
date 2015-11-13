FROM node:0.12.4
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

ENV COFFEE_VERSION=1.9.3

RUN npm install -g coffee-script@${COFFEE_VERSION}

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ENV NODE_ENV=production

ONBUILD COPY package.json /usr/src/app/
ONBUILD RUN npm_config_registry=http://localhost:4873 npm install
ONBUILD COPY . /usr/src/app

ONBUILD ENTRYPOINT ["coffee", "main.coffee", "--nodejs"]