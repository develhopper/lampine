#!/bin/bash

guide(){
		echo "lampine [start|stop|config]"
}

if [ $# -ne 1 ];then
		guide
		exit
fi

if [ ! -f ~/.lampinerc ];then
		echo "~/.lampinerc not found pleaser reinstall"
		exit
fi

. ~/.lampinerc

if [ ! -d $document_root ]
then
		mkdir -p $document_root
fi

if [ ! -d $data_dir ]
then
		mkdir -p $data_dir
fi


if [ ! -d $composer_home ]
then
		mkdir -p $composer_home
fi

if [ "$1" == "start" ]
then

	echo "Starting ..."
	echo "Document root: $document_root"
	echo "Mysql data directory: $data_dir"
	echo "Mysql password: $mysql_password"
	echo "Composer home: $composer_home"
	echo "Apache local port: $apache_port"
	echo "Mysql local port: $mysql_port"
	docker run -d -v $document_root:/var/www/localhost/htdocs/ -v $data_dir:/var/lib/mysql -v $composer_home:/root/.composer -e MYSQL_ROOT_PASSWORD=$mysql_password -p $apache_port:80 -p $mysql_port:3306 --name lampine-server develhopper/lampine 2> /dev/null

	if [ $? -eq 125 ];then
			echo "lampine-server is already running"
	fi

elif [ "$1" == "stop" ]
then
		echo "Stoping server ..."
		docker stop lampine-server>/dev/null 2>&1
		docker rm lampine-server>/dev/null 2>&1

elif [ "$1" == "config" ]
then
		vi ~/.lampinerc

else
		guide
fi
