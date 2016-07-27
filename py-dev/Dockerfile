FROM mhoush/tox

COPY entrypoint.sh /entrypoint.sh
ENV DEBUG "true"

ENTRYPOINT ["/entrypoint.sh", "activate"]

ONBUILD COPY . /usr/src/app
