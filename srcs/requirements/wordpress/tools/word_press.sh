#!/bin/bash
#-------------------------- wp-cli installation --------------------------#
install_wp_cli() 
{
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
}

#-------------------------- Set up WordPress directory permissions --------------------------#
setup_wp_permissions() 
{
    local wp_dir="/var/www/wordpress"
    chown -R www-data:www-data "$wp_dir"
    chmod -R 755 "$wp_dir"
}

#-------------------------- Check if MariaDB is running --------------------------#
ping_mariadb_container() 
{
    nc -zv mariadb 3306 > /dev/null
    return $?
}

wait_for_mariadb() 
{
    local start_time=$(date +%s)
    local end_time=$((start_time + 20))

    while [ $(date +%s) -lt $end_time ]; do
        ping_mariadb_container
        if [ $? -eq 0 ]; then
            echo "[****** MARIADB IS RUNNING ******]"
            return 0
        else
            echo "[****** WAITING FOR MARIADB TO START******]"
            sleep 1
        fi
    done

    echo "[***** MARIADB IS NOT RESPONDING ******]"
    return 1
}

#-------------------------- Install WordPress --------------------------#
install_wordpress() 
{
    local wp_dir="/var/www/wordpress"
    cd "$wp_dir" || exit 1
    wp core download --allow-root
    wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
    #final installation povide the site informations 
    wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_NAME" --admin_password="$WP_ADMIN_PASS" --admin_email="$WP_ADMIN_EMAIL" --allow-root
    wp user create "$WP_USER_NAME" "$WP_USR_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root
}

#-------------------------- PHP Configuration --------------------------#
configure_php() 
{
    #configuring PHP-FPM to listen on TCP port 9000 instead of a Unix socket.
    sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
    #hold runtime data and temporary files related to PHP-FPM (pid, logs ....)
    mkdir -p /run/php
    #path to php-fpm
    /usr/sbin/php-fpm7.4 -F
}

#-------------------------- Main --------------------------#
main() 
{
    install_wp_cli
    setup_wp_permissions
    
    if wait_for_mariadb; then
        install_wordpress
    else
        echo "Failed to connect to MariaDB. Exiting."
        exit 1
    fi
    configure_php
}

main