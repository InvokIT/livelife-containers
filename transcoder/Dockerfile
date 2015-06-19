FROM ubuntu:14.04
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

COPY install-avconv.sh /usr/local/bin/
RUN bash -c 'chmod +x /usr/local/bin/*.sh'

RUN /usr/local/bin/install-avconv.sh

COPY entrypoint.sh hls-transcode.sh /usr/local/bin/
RUN bash -c 'chmod +x /usr/local/bin/*.sh'

ENV LOG_PATH=/var/log/avconv.log
ENV HLS_OUT=/sink/hls
ENV DASH_OUT=/sink/dash

RUN mkdir -p ${LOG_PATH} ${HLS_OUT} ${DASH_OUT}

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]