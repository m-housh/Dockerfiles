Devpi-Server
===========

Heavily inspired by [muccg/devpi](https://github.com/muccg/docker-devpi).  But this image uses
alpine as base and has a much smaller footprint. < 78MB

Latest devpi-server version inside a docker-container.  This uses alpine:3.3 as the 
base image, for a minimal footprint.  This image is built without the ***devpi-client*** 
installed however on first initialization it will be installed  in order to set the root 
password, but once the server is initialized it will prompt you (if in interactive mode) if you 
would like to remove ***devpi-client***. If not in interactive mode it will go ahead and remove
***devpi-client***.

This image uses the `--restrict-modify` flag to restrict creation of new users and indexes 
to the root user. The root user's password should be set with the **DEVPI_PASSWORD**
environment variable.

### Usage
---------

```bash
$ docker pull mhoush/devpi-server
$ docker run -d --name devpi-server\
    -e DEVPI_PASSWORD=password \ # root user password
    -e PORT=3144 \ # use a custom port (default 3141)
    -v "${PWD}/data":/data \ # to persist data to the host
    -p "80:3144" \
    mhoush/devpi-server --web # enable devpi-web interface
```

### Options
----------

To maintain the smallest footprint for the use case, this image only comes with devpi-server.
The below options will install the ***devpi-web*** or ***devpi-client*** interfaces 
accordingly. All other options get passed into the ***devpi-server*** command used to start
    the server.  

>You can use below command to see available ***devpi-server*** options:  
>`$ docker run -it --rm mhoush/devpi-server --help`
 
* **-w | --web:**  
    Enable devpi-web
* **-c | --client:**  
    Enable the devpi-client

### Environment Options
-----------------------

>The following options are available to be set through enviornment variables.

* **DEVPI_PASSWORD:**  
    Used to set the password for the root user (defaults to '')
* **DEVPI_SERVERDIR:**  
    Used to set a custom directory for server files.
* **DEVPI_CLIENTDIR:**  
    Used to set a custom directory for client files.
* **PORT:**  
    Used to set a custom PORT to run the server on (defaults to 3141)
