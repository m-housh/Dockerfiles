FROM python:alpine

MAINTAINER mhoush@houshhomeenergy.com

RUN apk --update add --virtual build-deps \
    gcc \
    linux-headers \
    python-dev \
    musl-dev && \
    pip install uwsgi && \
    apk del build-deps

