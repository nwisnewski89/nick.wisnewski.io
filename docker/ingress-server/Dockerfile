FROM node:21-bullseye AS build

WORKDIR /app

COPY . .

RUN npm install -g npm@10.2.5

RUN npm install

RUN npm run build

RUN rm -rf node_modules

FROM nginx:1.24.0-alpine-slim AS server

EXPOSE 8080

RUN rm -rf /etc/nginx/conf.d

RUN rm -rf /etc/nginx/nginx.conf.default

COPY ./docker/nginx.conf /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=build /app/public .

ENTRYPOINT ["nginx", "-g", "daemon off;"]