FROM ubuntu:14.04.2
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get -q update && \
  apt-get -y -q dist-upgrade && \
  apt-get -y -q install rsyslog python-setuptools python-pip curl

RUN curl https://s3.amazonaws.com/aws-cloudwatch/downloads/latest/awslogs-agent-setup.py -o /root/awslogs-agent-setup.py

RUN sed -i "s/#\$ModLoad imudp/\$ModLoad imudp/" /etc/rsyslog.conf && \
  sed -i "s/#\$UDPServerRun 514/\$UDPServerRun 514/" /etc/rsyslog.conf && \
  sed -i "s/#\$ModLoad imtcp/\$ModLoad imtcp/" /etc/rsyslog.conf && \
  sed -i "s/#\$InputTCPServerRun 514/\$InputTCPServerRun 514/" /etc/rsyslog.conf

RUN sed -i "s/authpriv.none/authpriv.none,local6.none,local7.none/" /etc/rsyslog.d/50-default.conf

COPY awslogs.conf /root/awslogs.conf
RUN cd /root && python ./awslogs-agent-setup.py -n -r eu-west-1 -c ./awslogs.conf

RUN pip install supervisor
COPY supervisord.conf /usr/local/etc/supervisord.conf

EXPOSE 514

COPY entrypoint.sh /usr/sbin/entrypoint.sh
RUN chmod +x /usr/sbin/entrypoint.sh

ENTRYPOINT ["/usr/sbin/entrypoint.sh"]