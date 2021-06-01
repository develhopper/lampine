docker run -d -v "$PWD/test":/var/www/localhost/htdocs/ -v "$PWD/data":/var/lib/mysql -v ~/.composer:/root/.composer -e MYSQL_ROOT_PASSWORD=password -p 80:80 -p 3306:3306 develhopper/lampine
