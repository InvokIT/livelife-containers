#FROM debian:jessie
FROM ubuntu:14.04
MAINTAINER LiveLife Streaming <livelifestreaming@gmail.com>

ENV NGINX_VERSION=1.9.1 \
    NGINX_RTMP_VERSION=1.1.7

RUN apt-get -q -y update \
    && apt-get -q -y install build-essential libssl-dev \
        zlib1g-dev libpcre3 libpcre3-dev curl pgp \
    && apt-get -q -y build-dep nginx \
    && apt-get -q -y clean && rm -rf /var/cache/apt/archives/* /var/lib/apt/lists/*

RUN groupadd nginx && useradd -m -g nginx nginx
RUN mkdir -p /var/log/nginx /var/cache/nginx && chown nginx:nginx /var/log/nginx

RUN cd /root \
    && curl -L https://github.com/arut/nginx-rtmp-module/archive/v${NGINX_RTMP_VERSION}.tar.gz > nginx-rtmp.tgz \
    && mkdir nginx-rtmp && tar xzf nginx-rtmp.tgz -C nginx-rtmp --strip 1 

RUN mkdir -p /www && cp /root/nginx-rtmp/stat.xsl /www/stat.xsl && chown -R nginx:nginx /www

RUN cd /root \
    && curl -L http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz > nginx.tar.gz \
    && curl -L http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz.asc > nginx.tar.gz.asc \
    && gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-key A1C052F8 \
    && gpg nginx.tar.gz.asc \
    && mkdir nginx && tar xzf nginx.tar.gz -C nginx --strip 1 && cd nginx \
    && ./configure \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-file-aio \
        --add-module=/root/nginx-rtmp \
        --with-ipv6 \
   && make install

RUN rm -rf /root/*

RUN mkdir -p /var/log/app_engine/custom_logs

RUN ldconfig

EXPOSE 8080 1935

COPY nginx.conf /etc/nginx/
COPY entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]