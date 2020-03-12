FROM alpine:edge

MAINTAINER platform-team@seldatinc.com

RUN apk add --no-cache stunnel libressl

COPY entrypoint.sh /entrypoint.sh

VOLUME /etc/stunnel

RUN  ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]