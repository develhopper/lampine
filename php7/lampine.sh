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

if [ ! -f ~/.lampinerc7 ];then
		echo "~/.lampinerc not found please reinstall"
		exit
fi


. ~/.lampinerc7

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
	echo -e "$container_name"
	if docker inspect "$container_name" > /dev/null 2>&1; then
        echo "The container $container_name exists."
	if $(docker inspect -f '{{.State.Status}}' "$container_name" | grep -q "running"); then
                echo "The container $container_name is running."
        else
                echo "The container $container_name is not running."
                        docker start $container_name
                fi
        else
				echo "container not exists"
                docker run -d -v $document_root:/var/www/localhost/htdocs/ \
                -v $etc_dir:/root/.etc -v $data_dir:/var/lib/mysql -v $composer_home:/tmp/composer \
                -v $apache_logs:/var/log/apache2 \
                -e MYSQL_ROOT_PASSWORD=$mysql_password -p $apache_port:80 -p $mysql_port:3306 $append \
                --name lampine7-server develhopper/lampine7:latest
        fi
	if [ $? -eq 125 ];then
			echo -e "somthing is wrong. please make sure docker service is running\nor maybe container is already running"
	fi

elif [ "$1" == "stop" ];then
		echo "Stoping server ..."
		docker stop lampine7-server >/dev/null 2>&1

elif [ "$1" == "config" ];then
		vi ~/.lampinerc
elif [ "$1" == "status" ];then
	docker stats lampine7 --no-stream 2>/dev/null
	if [ $? -ne 0 ];then
			echo "server is not running"
	fi
elif [ "$1" == "sh" ];then
	docker exec -it --user $UID:$UID lampine7-server ash -l
elif [ "$1" == "shroot" ];then
	docker exec -it lampine7-server ash -l
elif [ "$1" == "reload" ];then
	docker exec lampine7-server cp -r /root/.etc/apache2 /etc
	docker exec lampine7-server cp -r /root/.etc/php7 /etc
	docker exec lampine7-server cp -r /root/.etc/lib/php7 /usr/lib/

	docker exec lampine7-server pkill httpd
	docker exec lampine7-server httpd
	echo -e "\nApache Reloaded \n"
else
		guide
fi
