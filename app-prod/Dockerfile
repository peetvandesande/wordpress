FROM wordpress

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
