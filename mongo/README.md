MONGO
=====

An alpine:edge image with mongodb.  The default behavior is to run mongo in
'--auth' mode.  This image will set a root username and password based on
environment variables at run time, you can also optionally set authentication
for one more database at run time.

Envirionment Variables:
----------------------

* **MONGO_ROOT_USERNAME:**  
    (defaults to 'root') The root username for the mongod instance.
* **MONGO_ROOT_PASSWORD:**  
    (defaults to 'password') The root password for the mongod instance.
* **MONGO_USERNAME:**  
    (defaults to '') The username to set as `dbOwner` of **MONGO_DBNAME**
* **MONGO_PASSWORD:**  
    (defaults to '') The password to set for **MONGO_USERNAME**
* **MONGO_DBNAME:** 
    (defaults to 'test') A db to create and set ownership of if the
    **MONGO_USERNAME** and **MONGO_PASSWORD** are present.

Examples
---------------------
Set the variables through an env-file.  Below will create the root username and password for the 'admin' database, and will also create user 'api_owner' as the 
`dbOwner` of the 'api' database.

**.env-file**
```bash
MONGO_ROOT_USERNAME="some_root"
MONGO_ROOT_PASSWORD="secret"
MONGO_USERNAME="api_owner"
MONGO_PASSWORD="super-secret"
MONGO_DBNAME="api"
```  

```bash
$ docker pull mhoush/mongo
$ docker run -d --name api_mongo \
    --env-file "$PWD/.env-file" \
    -p "27017:27017" \
    -v /path/to/data:/data/db
    mhoush/mongo
```
-----------------------
Same as above, but not using an env-file.
```bash
$ docker pull mhoush/mongo
$ docker run -d --name api_mongo \
    -e MONGO_ROOT_USERNAME="some_root" \
    -e MONGO_ROOT_PASSWORD="secret" \
    -e MONGO_USERNAME="api_owner" \
    -e MONGO_PASSWORD="super-secret" \
    -e MONGO_DBNAME="api" \
    -v /path/to/data:/data/db \
    -p "27017:27017"
    mhoush/mongo
```
---------------------
Passing other options to `mongod` at start-up.  If no options are passed, we call
`mongod --auth`, however if you pass additional options, then you need to include the `--auth`
option, if desired.
```bash
$ docker pull mhoush/mongo
$ docker run -d --name api_mongo \
    --env-file "$PWD/.env-file" \
    -p "27017:27017" \
    -v /path/to/data:/data/db
    mhoush/mongo mongod --auth --smallfiles
```
