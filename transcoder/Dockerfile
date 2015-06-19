FROM ubuntu:14.04
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

ENV LOG_PATH=/var/log/avconv.log
ENV HLS_OUT=/sink/hls
ENV DASH_OUT=/sink/dash

RUN mkdir -p ${LOG_PATH} ${HLS_OUT} {DASH_OUT}

COPY bin/* /usr/local/bin/
RUN chmod +x /usr/local/bin/*

RUN /usr/local/bin/install-avconv.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]