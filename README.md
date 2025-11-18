# wordpress
Wordpress + MariaDB and Redis DB Cache containers with custom PHP settings

Much inspiration taken from: https://www.dchost.com/blog/en/wordpress-on-docker-compose-without-the-drama-nginx-mariadb-redis-persistent-volumes-auto%E2%80%91backups-and-a-calm-update-flow/

This version is meant to run behind a reverse proxy so there is no SSL support. I'd recommend traefik for reverse proxy and SSL offloading.

Use 'setup.sh' to create a Docker environment file before starting up the containers.  

# Install  
./setup.sh  
docker compose up -d

# WP-CLI
For easy access to the WP-CLI, use an alias:
`echo "alias wp='docker compose run --rm wordpress-cli'" >> ~/.bash_aliases`

## Check for updates
wp core check-update

## Minor core updates only (safe):
wp core update --minor

## Plugin updates:
wp plugin update --all

## Theme updates:
wp theme update --all

## Search and replace (like, when moving from test (old domain=http://example-test.com/) to production (new domain=https://example.com/)
wp search-replace 'example-test' 'example' --dry-run
