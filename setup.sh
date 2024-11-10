#!/bin/bash
#
randompw () {
	</dev/urandom tr -dc '12345!@#%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c16; echo ""
}

randomstring () {
	</dev/urandom tr -dc '12345qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c8; echo ""
}

create_symlink () {
	ln -s docker-compose-${1}.yaml docker-compose.yaml
}

choose_role () {
	while [[ $role != "test" ]] && [[ $role != "prod" ]]; do
		read -p "Enter role [prod|test]: " role	
	done
	echo "${role}"
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
	prom_port_default=9090
	dbpass=`randompw`
	cache_key_salt=`randomstring`

	role=`choose_role`
	read -p "Enter database name [${dbname_default}]: " dbname
	read -p "Enter database user [${dbuser_default}]: " dbuser
	read -p "Enter webserver port [${web_port_default}]: " web_port
	read -p "Enter Prometheus port [${prom_port_default}]: " prom_port

	dbname=${dbname:-$dbname_default}
	dbuser=${dbuser:-$dbuser_default}
	web_port=${web_port:-$web_port_default}
	prom_port=${prom_port:-$prom_port_default}

	echo "DBNAME=${dbname}" > ${ENV_FILE}
	echo "DBUSER=${dbuser}" >> ${ENV_FILE}
	echo "DBPASS=${dbpass}" >> ${ENV_FILE}
	echo "WEB_PORT=${web_port}" >> ${ENV_FILE}
	echo "PROM_PORT=${prom_port}" >> ${ENV_FILE}

	if [[ ${role} == "test" ]]; then
		ssl_port_default=443
		read -p "Enter sslserver port [${ssl_port_default}]: " ssl_port
		ssl_port=${ssl_port:-$ssl_port_default}
		echo "SSL_PORT=${ssl_port}" >> ${ENV_FILE}

		mysql_root_pw=`randompw`
		echo "MARIADB_ROOT_PASSWORD=${mysql_root_pw}" >> ${ENV_FILE}

		pma_port_default=11080
		read -p "Enter pmaserver port [${pma_port_default}]: " pma_port
		pma_port=${pma_port:-$pma_port_default}
		echo "PMA_PORT=${pma_port}" >> ${ENV_FILE}
	fi

	echo "CACHE_KEY_SALT=${cache_key_salt}" >> ${ENV_FILE}

	`create_symlink ${role}`

	echo "Ready. Use: docker compose up [-d]"
fi
