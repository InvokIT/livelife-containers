FROM ubuntu:14.04
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

COPY install-avconv.sh /usr/local/bin/
RUN bash -c 'chmod +x /usr/local/bin/*.sh'

RUN /usr/local/bin/install-avconv.sh

COPY entrypoint.sh /usr/local/bin/
RUN bash -c 'chmod +x /usr/local/bin/*.sh'

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]