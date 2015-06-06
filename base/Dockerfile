FROM ubuntu:14.04.2
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

RUN apt-get -q -y update \
    && apt-get -q -y install cron logrotate make build-essential libssl-dev \
        zlib1g-dev libpcre3 libpcre3-dev curl pgp yasm \
    && apt-get -q -y clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*