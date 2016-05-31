FROM alpine:3.3

RUN apk add --no-cache \
    git \
    util-linux \
    bash \
    perl

RUN cd /tmp && \
    git clone https://github.com/datasift/gitflow /gitflow && \
    cd /gitflow && \
    sh install.sh && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/*

COPY ./entrypoint.sh /

VOLUME /repo
VOLUME /config

WORKDIR /repo

ENTRYPOINT ["/entrypoint.sh"]
