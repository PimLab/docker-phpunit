FROM pimlab/composer:latest-php7.1

RUN apk update && apk add wget git bash;

RUN wget --no-cache -O phpunit https://phar.phpunit.de/phpunit-7.phar \
    && chmod +x phpunit \
    && mv phpunit /usr/bin/phpunit;

RUN printf "# phpunit php cli ini settings\n\
memory_limit=-1\n\
" > $PHP_INI_DIR/php-cli.ini

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]

CMD ["phpunit"]