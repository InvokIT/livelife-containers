FROM node:5

ARG NPM_CONFIG_REGISTRY
RUN echo ${NPM_CONFIG_REGISTRY}

ENV COFFEE_VERSION=1.10.0

RUN npm install -g coffee-script@${COFFEE_VERSION}

RUN mkdir -p /usr/src/app/
WORKDIR /usr/src/app/

ENV NODE_ENV=production

COPY package.json /usr/src/app/
RUN npm install
COPY . /usr/src/app/

ENTRYPOINT ["npm", "start"]