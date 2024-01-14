FROM node:21-bullseye AS build

WORKDIR /app

COPY . .

RUN npm install -g npm@10.2.5

RUN npm install

RUN npm run build

RUN rm -rf node_modules

FROM nginx:1.24.0-bullseye AS server

EXPOSE 80

EXPOSE 443

RUN rm -rf /etc/nginx/conf.d

RUN rm -rf /etc/nginx/nginx.conf.default

COPY ./docker/nginx.conf /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=build /app/public .

RUN openssl req -x509 -newkey rsa:4096 -keyout key.pem -out cert.pem -sha256 -days 3650 -nodes -subj "/C=NW/ST=PA/L=Philadelphia/O=wisnewski.io/OU=Engineering/CN=nick.wisnewski.io"

ENTRYPOINT ["nginx", "-g", "daemon off;"]