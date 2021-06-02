
# lampine

Alpine LAMP stack

Docker image

## Installation

clone this repository

run

```bash

install.sh

```

after that you can start lamp server by running

```bash

lampine start

```

### Change default directories and ports
edit ~/.lampinerc

or run 

```bash
lampine config
```

## Edit php and apache configurations

edit files in $etc_dir
default path of etc_dir is

~/.local/share/lampine/etc

#### reload apache
to reload apache run this command

```bash
lampine reload
```
#### phpmyadmin

open localhost/phpmyadmin url in your browser

## Manual

lampine (start|stop|config|status|reload|sh) [local_port:port]

example:
```
lampine start 8000:8000
```

```
lampine start
```


** local_port:port ** is optional for exposing additional port


### Arguments explained

start: starts lamp server

stop: stops lamp server

config: to change default directories path and default ports

status: show server (container) status

sh: open an interactive shell attached to container

reload: reload apache server