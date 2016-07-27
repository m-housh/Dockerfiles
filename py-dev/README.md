mhoush/py-dev
=============

Python development container. Used to develop and test your package inside it's 
own container.  Adds current working directory `ONBUILD` to `/usr/src/app` 
inside the container.

This image has an entrypoint that adds to commands.

1. install
    * used to setup a `pyenv-virtualenv` for your package.  Install's any 
    `requirement*.txt` files in the `pyenv-virtualenv`, and if there's a
    setup.py in `/usr/src/app` it will install your app with 
    `pip install -e`.
2. activate [ARGS]
    * activates the `pyenv-virtualenv` for your project. Then calls any
    other args passed from command line.  This is the default
    `ENTRYPOINT` for any `docker run` commands.  To override set
    the `ENTRYPOINT` to something different in your development
    Dockerfile.

Usage
-----

Dockerfile.dev
``` docker
FROM mhoush/py-dev

ENV PROJECT py-dev-test
ENV PROJECT_PYTHON 3.5.0

RUN /bin/bash /entrypoint.sh install
```

Build the dev container.
``` bash
$ docker build -t py_dev_test:dev -f Dockerfile.dev .
```

Run commands in the container
``` bash
$ docker run --rm py_dev_test:dev pip freeze
```

Open a bash shell
```
$ docker run -it --rm py_dev_test:dev bash
```


Python
--------
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
* pyenv-virtualenv
