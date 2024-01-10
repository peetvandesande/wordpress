# wordpress
Wordpress + MariaDB containers with custom PHP settings

Based on https://github.com/docker-library/wordpress/latest/php8.2/apache

This container is meant to run behind a reverse proxy so there is no SSL support.  

Use 'setup.sh' to create a Docker environment file before starting up the containers.  

# Install  
./setup.sh  
docker compose up -d
