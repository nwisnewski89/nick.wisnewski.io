FROM nginx:1.24.0-alpine-slim

EXPOSE 80

EXPOSE 443

RUN rm -rf /etc/nginx/conf.d

RUN rm -rf /etc/nginx/nginx.conf.default

COPY ./docker/ingress-server/nginx.conf /etc/nginx/nginx.conf

ENTRYPOINT ["nginx", "-g", "daemon off;"]
#deploy