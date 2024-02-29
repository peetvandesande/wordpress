# wordpress
Wordpress + MariaDB and Redis DB Cache containers with custom PHP settings

Based on https://github.com/docker-library/wordpress/tree/ac65dab91d64f611e4fa89b5e92903e163d24572/latest/php8.2

This container is meant to run behind a reverse proxy so there is no SSL support.  

Use 'setup.sh' to create a Docker environment file before starting up the containers.  

When run in the 'test' role (choose during setup), a phpMyAdmin container is added.

# Install  
./setup.sh  
docker compose up -d


