FROM qvazar/avconv:latest
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

COPY index-template.m3u8 /usr/src/index-template.m3u8
COPY hls-transcode.sh /usr/local/bin/transcode
RUN chmod +x /usr/local/bin/transcode

RUN mkdir -p /var/hls /var/log/avconv

ENV TRANSCODE_OUT=/var/hls
ENV TRANSCODE_BASEURL=""

ENTRYPOINT ["/usr/local/bin/transcode"]