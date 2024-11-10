FROM wordpress:6-apache

# Install redis
RUN set -eux; \
	pecl install redis-5.3.7 \
	&& docker-php-ext-enable redis

# Add custom php values to .htaccess
RUN set -eux; \
	{ \
		echo '# BEGIN custom_PHP_values'; \
		echo ''; \
		echo '# Allowing for big uploads (restore backups)'; \
		echo 'php_value upload_max_filesize 500M'; \
		echo 'php_value post_max_size 500M'; \
		echo 'php_value memory_limit 256M'; \
		echo 'php_value max_execution_time 300'; \
		echo 'php_value max_input_time 300'; \
		echo ''; \
		echo '# END custom_PHP_values'; \
	} >> /usr/src/wordpress/.htaccess;

# Bring in custom php.ini
COPY php.ini-production /usr/local/etc/php/php.ini

# ---
# Enable SSL
RUN set -eux; \
	apt-get update; \
	apt-get install ssl-cert; \
	a2enmod ssl; \
	a2ensite default-ssl

#
# Enable mod_status
RUN set -eux; \
	sed -i 's/Require local/&\n\tRequire ip 10.0.0.0\/8 172.16.0.0\/12 192.168.0.0\/16/' /etc/apache2/mods-enabled/status.conf
