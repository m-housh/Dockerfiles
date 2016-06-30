#!/bin/sh

# short circuit if first arg is not 'mongod'
[ "$1" = "mongod" ] || exec "$@" || exit $? 

user=mongodb

: ${MONGO_ROOT_USERNAME="root"}
: ${MONGO_ROOT_PASSWORD="password"}
: ${MONGO_USERNAME}
: ${MONGO_PASSWORD}
: ${MONGO_DBNAME="test"}

# set permissions to user 'mongodb' on /data/db
[ "$(stat -c %U /data/db)" = "$user" ] || chown -R "$user" /data/db


if ! [ -f /entrypoint/passwords_set ]; then

    eval busybox su -s /bin/sh -c "mongod" "$user" &

    RET=1
    while [ $RET -ne 0 ]; do
        sleep 3
        mongo admin --eval "help" >/dev/null 2>&1
        RET=$?
    done

    # set the root user
    mongo admin --eval \
        "db.createUser({ user: '$MONGO_ROOT_USERNAME',
            pwd: '$MONGO_ROOT_PASSWORD',
            roles: [{ role: 'root', db: 'admin'}]
        });"

    if [ "$MONGO_USERNAME" != "" ] && [ "$MONGO_PASSWORD" != "" ]; then
        mongo admin <<EOF
        use $MONGO_DBNAME
        db.createUser({ user: '$MONGO_USERNAME',
            pwd: '$MONGO_PASSWORD',
            roles: [{ role: 'dbOwner', db: '$MONGO_DBNAME' }]
        });
EOF
    fi

    touch /entrypoint/passwords_set
    mongod --shutdown
fi

cmd="$@"
[ $# -eq 1 ] && cmd="$cmd --auth"

exec busybox su -s /bin/sh -c "$cmd" "$user"
