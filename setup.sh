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
		rm docker_compose.yaml
	fi
else
	dbname_default=wordpress
	dbuser_default=wp-user
	web_port_default=80
	dbpass=`randompw`
	cache_key_salt=`randomstring`

	dbname=${dbname:-$dbname_default}
	dbuser=${dbuser:-$dbuser_default}
	web_port=${web_port:-$web_port_default}

	echo "DBNAME=${dbname}" > ${ENV_FILE}
	echo "DBUSER=${dbuser}" >> ${ENV_FILE}
	echo "DBPASS=${dbpass}" >> ${ENV_FILE}
	echo "WEB_PORT=${web_port}" >> ${ENV_FILE}

	echo "CACHE_KEY_SALT=${cache_key_salt}" >> ${ENV_FILE}

	echo "Ready. Use: docker compose up [-d]"
fi
