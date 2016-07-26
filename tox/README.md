mhoush/tox
==========

An image for testing python packages. Uses `higebu/tox` as a starting
point, which is based off of `alpine:latest` docker image.

On build this copy's current working diretory to `/usr/src/app`.
The default command is `make test-all`.


Python Versions
---------------
* 2.7.10
* 3.3.6 
* 3.4.3 
* 3.5.0

Python Packages
---------------
* pip=8.1.2
* tox

Alpine Packages
---------------
* make
* pyenv
