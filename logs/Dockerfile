FROM nginx:latest

EXEC mkdir -p /shared/logs
VOLUME /shared

EXEC rm -rf /usr/share/nginx/html && ln -s /shared/logs /usr/share/nginx/html

EXPOSE 80