#!/bin/bash
#
randompw () {
    </dev/urandom tr -dc '12345!@#%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c16; echo ""
}

randomstring () {
    </dev/urandom tr -dc '12345qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c8; echo ""
}

ENV_FILE=${1:-".env"}

if [ -f ${ENV_FILE} ]; then
    echo "${ENV_FILE} already exists."
    read -p "Reset environment? [y/N] : " reset
    reset=${reset:-N}
    if [[ ${reset} == "y" ]]; then
        rm .env
    else
        # Simply quit
        exit 0
    fi
fi

site_id_default=example
dbname_default=wordpress
dbuser_default=wp-user
web_port_default=80
dbpass=`randompw`
cache_key_salt=`randomstring`

read -p "Enter Site ID: [${site_id_default}]: " site_id
site_id=${site_id:-$site_id_default}
domain_default=${site_id}.com
read -p "Enter domain name (don't include \"www.\") [${domain_default}]: " domain
read -p "Enter database name [${dbname_default}]: " dbname
read -p "Enter database user [${dbuser_default}]: " dbuser
read -p "Enter webserver port [${web_port_default}]: " web_port

domain=${domain:-$domain_default}
dbname=${dbname:-$dbname_default}
dbuser=${dbuser:-$dbuser_default}
web_port=${web_port:-$web_port_default}

# Strip leading "www." if user accidentally typed it
domain=${domain#www.}

# Regex-safe variants: replace "." with "\."
domain_regex="${domain//./\\.}"
www_domain="www.${domain}"
www_domain_regex="www.${domain_regex}"

# Write .env
echo "SITE_ID=${site_id}"                   >  "${ENV_FILE}"
echo "DOMAIN=${domain}"                     >> "${ENV_FILE}"
echo "WWW_DOMAIN=${www_domain}"             >> "${ENV_FILE}"
echo "DOMAIN_REGEX=${domain_regex}"         >> "${ENV_FILE}"
echo "WWW_DOMAIN_REGEX=${www_domain_regex}" >> "${ENV_FILE}"
echo "DBNAME=${dbname}"                     >> "${ENV_FILE}"
echo "DBUSER=${dbuser}"                     >> "${ENV_FILE}"
echo "DBPASS=${dbpass}"                     >> "${ENV_FILE}"
echo "WEB_PORT=${web_port}"                 >> "${ENV_FILE}"
echo "CACHE_KEY_SALT=${cache_key_salt}"     >> "${ENV_FILE}"

# Ask about adding alias
echo
read -p "Add alias to ~/.bash_aliases (see README.md)? [y/N]: " add_alias_input

case "$add_alias_input" in
    [yY]|[yY][eE][sS])
        echo "alias wp='docker compose run --rm wordpress-cli'" >> ~/.bash_aliases && source ~/.bash_aliases
        ;;
    *)                 use_alias=false ;;
esac

# Ask about Traefik usage
echo
read -p "Use Traefik (shared 'proxy' network, HTTPS routing)? [y/N]: " use_traefik_input

case "$use_traefik_input" in
    [yY]|[yY][eE][sS]) use_traefik=true ;;
    *)                 use_traefik=false ;;
esac

echo "USE_TRAEFIK=${use_traefik}"          >> "${ENV_FILE}"

compose_file="docker-compose.yml"

if [ -f "${compose_file}" ]; then
    if [ "${use_traefik}" = true ]; then
        echo "Enabling Traefik-related sections in ${compose_file}..."

        sed -i -E '
/^[[:space:]]*#[[:space:]]*labels:/ s/^([[:space:]]*)#[[:space:]]*(labels:)/\1\2/;
/^[[:space:]]*#[[:space:]]*-[[:space:]]*".*traefik\..*"/ s/^([[:space:]]*)#[[:space:]]*(.*)/\1\2/;
/^[[:space:]]*#[[:space:]]*-[[:space:]]*proxy[[:space:]]+# To communicate with Traefik/ s/^([[:space:]]*)#[[:space:]]*(.*)/\1\2/;
/^[[:space:]]*#[[:space:]]*proxy:/ s/^([[:space:]]*)#[[:space:]]*(proxy:)/\1\2/;
/^[[:space:]]*#[[:space:]]*external:[[:space:]]*true/ s/^([[:space:]]*)#[[:space:]]*(external:[[:space:]]*true)/\1\2/;
        ' "${compose_file}"

    else
        echo "Disabling Traefik-related sections in ${compose_file}..."

        sed -i -E '
/^[[:space:]]*labels:/ s/^([[:space:]]*)(labels:)/\1# \2/;
/^[[:space:]]*-[[:space:]]*".*traefik\..*"/ s/^([[:space:]]*)(-.*)/\1# \2/;
/^[[:space:]]*-[[:space:]]*proxy[[:space:]]+# To communicate with Traefik/ s/^([[:space:]]*)(-.*)/\1# \2/;
/^[[:space:]]*proxy:/ s/^([[:space:]]*)(proxy:)/\1# \2/;
/^[[:space:]]*external:[[:space:]]*true/ s/^([[:space:]]*)(external:[[:space:]]*true)/\1# \2/;
        ' "${compose_file}"
    fi
else
    echo "Warning: ${compose_file} not found, skipping Traefik toggling."
fi

echo
echo "Ready. Use: docker compose up [-d]"

