FROM ubuntu:14.04
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

COPY install-avconv.sh /usr/local/bin/
RUN bash -c 'chmod +x /usr/local/bin/*.sh'

RUN /usr/local/bin/install-avconv.sh

COPY entrypoint.sh hls-transcode.sh /usr/local/bin/
RUN bash -c 'chmod +x /usr/local/bin/*.sh'

COPY hls-index-template.m3u8 /etc/

ENV ETCD_HOST=10.1.42.1 ETCD_PORT=2379

VOLUME /sink

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]