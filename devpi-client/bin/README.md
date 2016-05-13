Devpi Utility Script
====================

This utility is used as a convenience helper to start `mhoush/docker-devpi-client`.  Which 
performs `devpi-client` commands inside a docker container. This script is written for OS X, 
so may require some items to be removed if using docker on another platform.  It is also write
for `zsh` however should work in `bash` as well.

### Settings
---

You should adjust the following settings after copying this file to your `bin`.

1.  **DEVPI_USER**  
    Set to your username for ***devpi-server*** if applicable or "" if not.
2.  **DEVPI_URL**  
    Set to the url for your ***devpi-server***.
3.  **DEVPI_USE**  
    Set to the index to use after login to your ***devpi-server***.


### Installation
---

```bash
$ git clone https://github.com/m-housh/docker-devpi-client.git
$ cd docker-devpi-client
$ cp bin/devpi ~/.bin # or somewhere in your PATH (ex. /usr/local/bin)
$ vim ~/.bin/devpi # adjust the settings accordingly.
$ cd /your/project/directory
$ devpi upload --with-docs
```

