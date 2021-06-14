
# lampine

Alpine LAMP stack with php8 mysql and phpmyadmin

Docker image

## Installation

clone this repository

https://github.com/develhopper/lampine

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

#### Reload apache
after editing apache and php configuration files you need reload apache
to reload apache run this command

```bash
lampine reload
```
#### PhpMyAdmin

open  ```http://localhost/phpmyadmin``` url in your browser

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

sh: open an interactive shell (as local user id) attached to container

shroot: open an intractive shell as root user attached to container

reload: reload apache server
