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

EXPOSE 8082

RUN rm -rf /etc/nginx/conf.d

RUN rm -rf /etc/nginx/nginx.conf.default
  
RUN mkdir /etc/nginx/templates

COPY ./docker/site/default.conf.template /etc/nginx/templates

WORKDIR /usr/share/nginx/html

RUN rm -rf ./*

COPY --from=build /app/public .