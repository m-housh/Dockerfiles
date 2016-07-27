FROM higebu/tox

ARG PWD

RUN apk add --update \
    make && \
    pyenv install 3.3.6 && \
    pyenv global 3.5.0 2.7.10 3.4.3 3.3.6 && \
    pip install --upgrade pip==8.1.2 && \
    rm -rf /var/tmp/* /var/cache/apk/* /tmp/*

ONBUILD COPY ${PWD} /usr/src/app
VOLUME /usr/src/app
WORKDIR /usr/src/app

CMD ["make", "test-all"]
