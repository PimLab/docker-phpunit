FROM php:7.0-cli-stretch

RUN apt-get update && apt-get install -y wget libc6 libgnutls30 libidn11 libnettle6 libpcre3 libpsl5 libuuid1 zlib1g libssl-dev git bash;

RUN wget -O phpunit https://phar.phpunit.de/phpunit-6.phar \
    && chmod +x phpunit \
    && mv phpunit /usr/bin/phpunit;

RUN printf "# phpunit php cli ini settings\n\
memory_limit=-1\n\
" > $PHP_INI_DIR/php-cli.ini

COPY docker-entrypoint.sh /docker-entrypoint.sh

ENTRYPOINT ["/bin/bash", "/docker-entrypoint.sh"]

CMD ["phpunit"]