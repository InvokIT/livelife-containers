FROM nginx:latest

RUN mkdir -p /shared/logs
VOLUME /shared

RUN rm -rf /usr/share/nginx/html && ln -s /shared/logs /usr/share/nginx/html

EXPOSE 80