FROM ubuntu:14.04
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

RUN apt-get -q -y update \
    && apt-get -q -y install curl \
    && apt-get -q -y clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

# ENV HEARTBEAT_TOKEN_URL=URL to set token at
ENV HEARTBEAT_TOKEN_TTL=5 HEARTBEAT_TOKEN_VALUE=1

COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]