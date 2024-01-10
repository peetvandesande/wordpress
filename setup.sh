#!/bin/bash
#
randompw () {
	</dev/urandom tr -dc '12345!@#$%qwertQWERTasdfgASDFGzxcvbZXCVB' | head -c16; echo ""
}

ENV_FILE=${1:-".env"}

if [ -f ${ENV_FILE} ]; then
	echo "${ENV_FILE} already exists. Remove it before running this."
else
	dbname_default=wordpress
	dbuser_default=wp-user
	web_port_default=8080
	dbpass=`randompw`

	read -p "Enter database name [${dbname_default}]: " dbname
	read -p "Enter database user [${dbuser_default}]: " dbuser
	read -p "Enter webserver port [${web_port_default}]: " web_port

	dbname=${dbname:-$dbname_default}
	dbuser=${dbuser:-$dbuser_default}
	web_port=${web_port:-$web_port_default}

	echo "DBNAME=${dbname}" > ${ENV_FILE}
	echo "DBUSER=${dbuser}" >> ${ENV_FILE}
	echo "DBPASS=${dbpass}" >> ${ENV_FILE}
	echo "WEB_PORT=${web_port}" >> ${ENV_FILE}

	echo ""
	echo "Done creating ${ENV_FILE}:"
	cat ${ENV_FILE}
fi
