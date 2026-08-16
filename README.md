# wordpress
Wordpress + MariaDB and back-up containers with custom settings for large uploads and long caches.  

Caching configuration in nginx configuration (nginx/nginx.conf and nginx/conf.d/default.conf) is now marked clearly to help disable it for development sites or personal preference.

Much inspiration taken from [a blog on dchost.com](https://www.dchost.com/blog/en/wordpress-on-docker-compose-without-the-drama-nginx-mariadb-redis-persistent-volumes-auto%E2%80%91backups-and-a-calm-update-flow/).  

This version is meant to run behind a reverse proxy so there is no SSL support. I'd recommend traefik for reverse proxy and SSL offloading unless you already have a reverse proxy in place; the labels for traefik are already in the docker file to work with a Traefik container in a different environment. Uncomment or delete all labels if you don't use Traefik.  

The default Traefik labels redirect from https://example.com/ to https://www.site.com/ - if your Wordpress is set up to use https://site.com then disable this redirection to prevent endless redirections.  

Use 'setup.sh' to create a Docker environment file before starting up the containers.  

# Install  
```
./setup.sh  
docker compose up -d
```

# WP-CLI
For easy access to the WP-CLI, use an alias:  
`echo "alias wp='docker compose run --rm wordpress-cli'" >> ~/.bash_aliases && source ~/.bash_aliases`

## Check for updates
`wp core check-update`

## Minor core updates only (safe):
`wp core update --minor`

## Plugin updates:
`wp plugin update --all`

## Theme updates:
`wp theme update --all`

## Search and replace
(like, when moving from test (old domain=http://example-test.com/) to production (new domain=https://example.com/)  
`wp search-replace 'example-test' 'example' --dry-run`

# Backup
Backup is built-in using the respective file-backup and mariadb-backup containers. Make sure to mount the correct directory to store the backups.

# Restore
1. In the project root, extract the local files from the tarball
`tar xf wordpress-data-20260802.tar.zst --strip-components=1 local/`

2. Cut the ':ro' from the wordpress mount of the app-backup service definition in docker-compose.yml so it can write there
`.     - wordpress:/var/www/html`

3. Fire up the stack
`docker compose up -d`

4. Restore the database
`docker compose exec -it mariadb-backup sh`
`restore /backups/wordpress-dbwordpress-mariadb-20260802.sql.zst`
`exit`

5. Restore the files
`docker compose exec -it app-backup sh`
`tar xf wordpress-data-20260802.tar.zst var/`
`exit`

6. Verify the site is working as expected

7. Bring the stack down, restore the read-only mounting of wordpress under app-backup:
`.     - wordpress:/var/www/html:ro`

8. Done