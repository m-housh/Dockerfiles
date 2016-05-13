## Docker-Devpi-Client
-------------------

## Usage 

This image allows you to run ***devpi-client*** commands inside a docker container.  All commands 
get sent to `devpi` unless you use `sh` or `bash` will open a shell session inside the
container.  There is also a utility script for easier start-up/access to using the 
devpi-client from your host machine.  See the 
[github repo](https://github.com/m-housh/docker-devpi-client/tree/master/bin) for installation.



```bash
$ docker pull mhoush/docker-devpi-client:latest
$ docker run -it --rm \
    -v "${PWD}":/mnt \
    -v "${PWD}/venv/lib/python3.5/site-packages":/site-packages \
    -v "${HOME}/.certs":/certs \
    -e DEVPI_USER=devpi \
    -e DEVPI_URL=http://localhost:8080/packages \
    -e DEVPI_USE=dev \
    mhoush/docker-devpi-client upload --with-docs

```


#### Volumes:  
---

1. **/mnt**:   
    Where to mount your source code, for upload.
2. **/site-packages:**

    Where to mount your virtual-env site-packages directory if installing
    from a devpi server.  If this directory is not empty then it will
    set the envirnment variable's PIP_TARGET and PYTHONPATH to point to
    the /site-packages directory.
3. **/root/.pip:**  
    Where to mount a custom ~/.pip/pip.conf
4. **/certs:**  
    Where to mount custom CA certs.  If this directory is not empty
    then it will copy the certs into another directory and run the
    openssl c_rehash utility on that directory, which is required
    for requests to validate certificates.

#### Environment Variables:
---

 
 1. **DEVPI_URL:**  
    Your devpi server url. If not empty then will run `devpi use "${DEVPI_URL}"` before your
    commands.
2. **DEVPI_USER:**  
    Your username.  If not empty then will run `devpi login "${DEVPI_USER}"` before your 
    commands.
3. **DEVPI_USE:**  
    Index to use after login. If not empty then will run `devpi use "${DEVPI_USE}"` before
    your commands.

### Examples:
---


*Upload a project to your devpi server and exit the container.*
```bash
$ docker run -it --rm \
    -v "${PWD}":/mnt \
    -v "${PWD}/venv/lib/python3.5/site-packages":/site-packages \
    -v "${HOME}/.certs":/certs \
    -e DEVPI_USER=devpi \
    -e DEVPI_URL=http://localhost:8080/packages \
    -e DEVPI_USE=dev \
    mhoush/docker-devpi-client upload --with-docs
```
*Open an interactive shell in the container.*
```bash
$ docker run -it --rm \
    -h docker-devpi\ # host name to make the shell prompt look nicer
    -v "${PWD}":/mnt \
    mhoush/docker-devpi-client bash

=> starting shell...
root@docker-devpi:/mnt$  devpi use http://your.devpi.com/
# more commands
...
root@docker-devpi:/mnt$ exit
```


