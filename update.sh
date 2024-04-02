# update script
#
# Simple 'docker compose restart' will not apply updated images

# download latest images
docker compose pull

# Bring the environment down:
docker compose down

# Forcefully rebuild containers
docker compose up --force-recreate --build -d
