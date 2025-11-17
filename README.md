# wordpress
Wordpress + MariaDB and Redis DB Cache containers with custom PHP settings

Much inspiration taken from: https://www.dchost.com/blog/en/wordpress-on-docker-compose-without-the-drama-nginx-mariadb-redis-persistent-volumes-auto%E2%80%91backups-and-a-calm-update-flow/

The production version is meant to run behind a reverse proxy so there is no SSL support.  

Use 'setup.sh' to create a Docker environment file before starting up the containers.  

When run in the 'test' role (choose during setup), a phpMyAdmin container and self-signed SSL certificate is added

# Install  
./setup.sh  
docker compose up -d

# WP-CLI
For easy access to the WP-CLI, use an alias:
`echo "alias wp='docker exec -it wordpress wp' >> ~/.bash_aliases`

## Check for updates
docker compose exec wordpress wp core check-update

## Minor core updates only (safe):
docker compose exec wordpress wp core update --minor

## Plugin updates:
docker compose exec wordpress wp plugin update --all

## Theme updates:
docker compose exec wordpress wp theme update --all