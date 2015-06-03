FROM livelife/avconv:latest
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

VOLUME /var/hls

COPY hls-transcode.sh /usr/sbin/transcode
RUN chmod +x /usr/sbin/transcode

ENTRYPOINT ["/usr/sbin/transcode"]