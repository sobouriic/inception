#!/bin/bash

#-------------- Start MariaDB --------------#
start_mariadb() 
{
    service mariadb start
    sleep 5  
}

#-------------- Configure MariaDB --------------#
configure_mariadb() 
{
    mariadb -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DB}\`;"
    mariadb -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    mariadb -e "GRANT ALL PRIVILEGES ON ${MYSQL_DB}.* TO \`${MYSQL_USER}\`@'%';"
    mariadb -e "FLUSH PRIVILEGES;"
}

#-------------- Restart MariaDB --------------#
restart_mariadb() 
{
    mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
    mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
}

#-------------- Main --------------#
main() 
{
    start_mariadb
    configure_mariadb
    restart_mariadb
}

main