FROM ubuntu:14.04.2
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q -y update \
	&& apt-get -q -y install curl python-setuptools python-pip

RUN curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -o /root/awslogs-agent-setup.py

RUN pip install supervisor
COPY supervisord.conf /etc/supervisord.conf

ONBUILD COPY awslogs.conf /root/awslogs.conf

ONBUILD RUN printf "\n[general]\nstate_file = /var/awslogs/state/agent-state\n" >> /root/awslogs.conf

ONBUILD RUN cd /root && python ./awslogs-agent-setup.py -n -r eu-west-1 -c ./awslogs.conf

ONBUILD COPY entrypoint.sh /usr/local/bin/entrypoint.sh
ONBUILD RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/supervisord"]