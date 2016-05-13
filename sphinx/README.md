Sphinx
=====

Run's sphinx commands in a docker-container.  Default command is sphinx-quickstart

```bash
$ docker pull mhoush/sphinx
$ cd /your/project/docs
$ docker run -it --rm \
    -v "${PWD}":/mnt \
    mhoush/sphinx
```
