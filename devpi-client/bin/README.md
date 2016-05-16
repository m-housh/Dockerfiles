Devpi Utility Script
====================

This utility is used as a convenience helper to start `mhoush/devpi-client`.  Which 
performs `devpi-client` commands inside a docker container. This script is written for OS X and docker-machine, however should be portable, with some minor adjustments.  

### Settings
---

You should adjust the following settings after copying this file to your `bin`.

1.  **DEVPI_USER**  
    Set to your username for ***devpi-server*** if applicable or "" if not.
2.  **DEVPI_HOST**  
    Set to the host for your ***devpi-server***.
3.  **DEVPI_INDEX**  
    Set to the index to use after login to your ***devpi-server***.
4. **DEVPI_PORT**
    Set to the port of your ***devpi-server*** (if applicable)


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

