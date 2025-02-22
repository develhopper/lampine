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

if [ ! -d $php_libs ]
then
		mkdir -p $php_libs
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
	echo "Apache Logs: $apache_logs"
	echo -e "Mysql local port: $mysql_port \n"
	if docker inspect "$container_name" > /dev/null 2>&1; then
    	echo "The container $container_name exists."

    # Check if the container is running
    	if $(docker inspect -f '{{.State.Status}}' "$container_name" | grep -q "running"); then
        	echo "The container $container_name is running."
    	else
        	echo "The container $container_name is not running."
			docker start $container_name
		fi
	else
		docker run -d -v $document_root:/var/www/localhost/htdocs/ \
		-v $etc_dir:/root/.etc -v $data_dir:/var/lib/mysql -v $composer_home:/tmp/composer \
		-v $apache_logs:/var/log/apache2 \
		-e MYSQL_ROOT_PASSWORD=$mysql_password -p $apache_port:80 -p $mysql_port:3306 $append \
		--name lampine-server develhopper/lampine:latest 2>/dev/null
	fi
	if [ $? -eq 125 ];then
			echo -e "somthing is wrong. please make sure docker service is running\nor maybe container is already running"
	fi

elif [ "$1" == "stop" ];then
		echo "Stoping server ..."
		docker stop $container_name>/dev/null 2>&1

elif [ "$1" == "config" ];then
		vi ~/.lampinerc
elif [ "$1" == "status" ];then
	docker stats $container_name --no-stream 2>/dev/null
	if [ $? -ne 0 ];then
			echo "server is not running"
	fi
elif [ "$1" == "sh" ];then
	docker exec -it --user $UID:$UID $container_name ash -l
elif [ "$1" == "shroot" ];then
	docker exec -it $container_name ash -l
elif [ "$1" == "reload" ];then
	docker exec $container_name cp -r /root/.etc/apache2 /root/.etc/php8 /etc/
	docker exec $container_name cp -r /root/.etc/lib/php8/ /usr/lib
	docker exec $container_name pkill httpd
	docker exec $container_name httpd
	echo -e "\nApache Reloaded \n"
else
		guide
fi
