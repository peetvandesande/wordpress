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
`echo "alias wp='docker compose exec -it wordpress wp'" >> ~/.bash_aliases`

## Check for updates
[docker compose exec wordpress] wp core check-update

## Minor core updates only (safe):
[docker compose exec wordpress] wp core update --minor

## Plugin updates:
[docker compose exec wordpress] wp plugin update --all

## Theme updates:
[docker compose exec wordpress] wp theme update --all

## Search and replace (like, when moving from test (old domain=http://example-test.com/) to production (new domain=https://example.com/)
[docker compose exec wordpress] wp search-replace 'example-test' 'example' --dry-run
