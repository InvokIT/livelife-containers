FROM ubuntu:14.04.2
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

#ENV COFFEE_VERSION=1.9.3

#RUN npm install -g coffee-script@${COFFEE_VERSION}

COPY install-avconv.sh /root/install-avconv.sh
RUN chmod +x /root/install-avconv.sh
RUN /root/install-avconv.sh


ENV HLS_OUT=/sink/hls
ENV DASH_OUT=/sink/dash
ENV LOG_PATH=/var/log/avconv

RUN mkdir -p ${LOG_PATH} ${HLS_OUT} {DASH_OUT}

COPY entrypoint.sh /usr/sbin/entrypoint.sh
RUN chmod +x /usr/sbin/entrypoint.sh

ENTRYPOINT ["/usr/sbin/entrypoint.sh"]