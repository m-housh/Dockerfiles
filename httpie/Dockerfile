FROM mhoush/py3
MAINTAINER https://github.com/m-housh

RUN apk update && apk add \
    ca-certificates &&\
    pip install --no-cache-dir httpie && \
    rm -rf /var/cache/apk/* /root/.cache/*

ENTRYPOINT ["http"]
CMD ["--help"]
