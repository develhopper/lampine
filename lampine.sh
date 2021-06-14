#!/bin/bash

guide(){
		echo -e "Help: \n"
		echo -e "lampine (start|stop|config|status|reload|sh|shroot) [local_port:port] \n"
		echo -e "ex: lampine start 8000:8000"
		echo "ex: lampine start"
}

if [ $# -eq 0 ];then
		guide
		exit
fi

if [ ! -f ~/.lampinerc ];then
		echo "~/.lampinerc not found please reinstall"
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

if [ ! -d $apache_conf ]
then
		mkdir -p $apache_conf
fi

if [ ! -d $composer_home ]
then
		mkdir -p $composer_home
fi

if [ "$1" == "start" ];then
	append=""
	if [[ $# -eq 2 ]] && [[ "$2" =~ ^[0-9]+\:[0-9]+$ ]];then
		append=" -p $2"
	fi
	echo -e "Starting ... \n"
	echo "Document root: $document_root"
	echo "Mysql data directory: $data_dir"
	echo "Mysql password: $mysql_password"
	echo "Apache config dir: $apache_conf"
	echo "Composer home: $composer_home"
	echo "Apache local port: $apache_port"
	echo -e "Mysql local port: $mysql_port \n"
	docker run -d --rm -v $document_root:/var/www/localhost/htdocs/ \
	-v $etc_dir:/root/.etc -v $data_dir:/var/lib/mysql -v $composer_home:/root/.composer \
	-e MYSQL_ROOT_PASSWORD=$mysql_password -p $apache_port:80 -p $mysql_port:3306 $append \
	--name lampine-server develhopper/lampine:latest 2>/dev/null

	if [ $? -eq 125 ];then
			echo -e "somthin went wrong. please make sure docker service is running\n or maybe container already running"
	fi

elif [ "$1" == "stop" ];then
		echo "Stoping server ..."
		docker stop lampine-server>/dev/null 2>&1

elif [ "$1" == "config" ];then
		vi ~/.lampinerc
elif [ "$1" == "status" ];then
	docker stats lampine-server --no-stream 2>/dev/null
	if [ $? -ne 0 ];then
			echo "server is not running"
	fi
elif [ "$1" == "sh" ];then
	docker exec -it --user $UID:$UID lampine-server ash -l
elif [ "$1" == "shroot" ];then
	docker exec -it lampine-server ash -l
elif [ "$1" == "reload" ];then
	docker exec lampine-server cp -r /root/.etc/apache2 /root/.etc/php8 /etc/
	docker exec lampine-server pkill httpd
	docker exec lampine-server httpd
	echo -e "\nApache Reloaded \n"
else
		guide
fi
