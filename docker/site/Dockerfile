FROM node:21-bullseye AS base
 
RUN npm install -g npm@10.2.5

FROM base AS build

WORKDIR /app

COPY package.json .

COPY package-lock.json .

RUN npm ci

COPY . .

RUN npm run build

FROM nginx:1.24.0-alpine-slim AS server

EXPOSE 8080

RUN rm -rf /etc/nginx/conf.d

RUN rm -rf /etc/nginx/nginx.conf.default

COPY ./docker/site/nginx.conf /etc/nginx/nginx.conf

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=build /app/public .

ENTRYPOINT ["nginx", "-g", "daemon off;"]
#build-me