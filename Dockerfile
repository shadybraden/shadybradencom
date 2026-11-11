# renovate: datasource=docker depName=hugomods/hugo
ARG HUGO_VERSION=0.165.0
# renovate: datasource=docker depName=nginxinc/nginx-unprivileged
ARG NGINX_VERSION=1.31.8

FROM docker.io/hugomods/hugo:${HUGO_VERSION} AS builder

WORKDIR /src
COPY . .

RUN hugo build --minify --environment production --destination /output

FROM docker.io/nginxinc/nginx-unprivileged:${NGINX_VERSION}-alpine

COPY default.conf /etc/nginx/conf.d/default.conf
COPY --from=builder --chown=101:101 /output /usr/share/nginx/html

EXPOSE 8088
