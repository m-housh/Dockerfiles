#  mhoush/py3:devpi

This image is used to utilize a private devpi-server as a search index for python package 
installs during a docker build.

#### Build-Args
* host:  The host ip of the devpi-server (do not need to set it if the devpi-server is running
    in a docker container on the same host)
* index: The devpi index to use as the search index (default's to mhoush/dev)
