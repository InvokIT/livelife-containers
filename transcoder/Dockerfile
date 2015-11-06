#FROM debian:jessie
FROM ubuntu:14.04
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

COPY install-avconv.sh /usr/local/bin/
RUN bash -c 'chmod +x /usr/local/bin/*.sh'

RUN /usr/local/bin/install-avconv.sh

ENV LOG_PATH=/var/log/app_engine/custom_logs
RUN mkdir -p /var/log/app_engine/custom_logs

COPY entrypoint.sh hls-transcode.sh /usr/local/bin/
RUN bash -c 'chmod +x /usr/local/bin/*.sh'

COPY hls-index-template.m3u8 /etc/

VOLUME /sink

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]