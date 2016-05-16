## Docker-Devpi-Client
-------------------

## Usage 

This image allows you to run ***devpi-client*** commands inside a docker container.  All commands 
get sent to `devpi` unless you use `sh [args..]` will open a shell session inside the
container.  There is also a utility script for easier start-up/access to using the 
devpi-client from your host machine.  See the 
[github repo](https://github.com/m-housh/Dockerfiles/tree/master/devpi-client/bin) for installation.



```bash
$ docker pull mhoush/docker-devpi-client:latest
$ docker run -it --rm \
    -v "${PWD}":/mnt \
    -v "${PWD}/venv/lib/python3.5/site-packages":/site-packages \
    -v "${HOME}/.certs":/certs \
    -e DEVPI_USER=devpi \
    -e DEVPI_URL=http://localhost:3141/packages \
    -e DEVPI_INDEX=/devpi/dev \
    mhoush/devpi-client [options...] [args...]
```
#### Options
---
The following options can be passed into the container before any devpi commands for set
up of the devpi session.
* **-h | --help:**  
    Show help pages.
* **--host:**  
    Set the devpi-host url.
* **--index:**  
    Set the devpi index to connect to
* **--user:**  
    Set the devpi user (if needed for login purposes)
* **--password:**  
    Set the devpi user's password (if needed for login purposes).  If in interactive mode
    then you can supply this when prompted during the login process.
* **--login:**  
    Force a login before any devpi commands.

#### Args
---
All the args get passed into the devpi command.  
>To show devpi commands, use below.  
`docker run --rm mhoush/devpi-client --help`  
or:  
`docker run --rm mhoush/devpi-client [command] --help`


#### Volumes:  
---

* **/mnt**:   
    Where to mount your source code, for upload.
* **/site-packages:**
    Where to mount your virtual-env site-packages directory if installing
    from a devpi server.  If this directory is not empty then it will
    set the envirnment variable's PIP_TARGET and PYTHONPATH to point to
    the /site-packages directory.
* **/root/.pip:**  
    Where to mount a custom ~/.pip/pip.conf
* **/certs:**  
    Where to mount custom CA certs to verify requests to your devpi server (if you use a
    self signed certificate for your server).  If this directory is not empty then it will copy the certs into another directory and run the **OPENSSL** `c_rehash` utility on that directory, which is required for requests to validate certificates. There will be no consequences for you, and will not affect or change any of the certs that you mount.

#### Environment Variables:
---

 
* **DEVPI_URL:**  
    Your devpi server url. If not empty then will run `devpi use "${DEVPI_URL}"` before your
    commands.
* **DEVPI_USER:**  
    Your username.  If not empty then will run `devpi login "${DEVPI_USER}"` before your 
    commands.
* **DEVPI_USE:**  
    Index to use after login. If not empty then will run `devpi use "${DEVPI_USE}"` before
    your commands.
* **DEVPI_PASSWORD:**  
    Set the login password.  (Use at your own risk, if used as environment variable and
    you push/commit an image then it will still be in the environment)
* **DEVPI_KEEP_ALIVE:**  
    If "true" then after any devpi commands you will get a shell prompt, if "false" 
    (default) then the container will exit after the devpi commands.

### Examples:
---


*Upload a project to your devpi server and exit the container.*
```bash
$ docker run -it --rm \
    -v "${PWD}":/mnt \
    -v "${PWD}/venv/lib/python3.5/site-packages":/site-packages \
    -v "${HOME}/.certs":/certs \
    -e DEVPI_USER=devpi \
    -e DEVPI_URL=http://localhost:3141/packages \
    -e DEVPI_INDEX=dev \
    mhoush/devpi-client --password "password" upload --with-docs
```
*Open an interactive shell in the container.*
```bash
$ docker run -it --rm \
    -v "${PWD}":/mnt \
    mhoush/devpi-client sh

=> starting shell...
/mnt$  devpi use http://your.devpi.com/
# more commands
...
/mnt$ exit
```


