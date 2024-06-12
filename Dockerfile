FROM alpine:3.20

LABEL maintainer="https://github.com/zhangliqiang/nginx-docker"

ENV NGINX_VERSION 1.27.0

RUN set -x \
    && addgroup -g 101 -S nginx \
    && adduser -S -D -H -u 101 -h /var/cache/nginx -s /sbin/nologin -G nginx -g nginx nginx
RUN apk add --update --no-cache build-base pcre pcre-dev openssl openssl-dev zlib zlib-dev curl wget iputils busybox-extras vim
RUN cd /tmp \
    && wget http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz \
    && tar -zxvf nginx-$NGINX_VERSION.tar.gz \
    && cd nginx-$NGINX_VERSION \
    && ./configure --user=nobody --group=nobody \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    --with-stream \
    --with-http_realip_module \
    --with-http_v2_module \
    --with-http_v3_module \
    --with-compat \
    --with-threads \
    --with-file-aio \
    --with-http_sub_module \
    && make \
    && make install \
    && rm -rf /tmp/* /var/tmp/* /var/cache/apk/*


EXPOSE 80 443

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]