FROM php:8.3-fpm

RUN apt-get update && apt-get install -y unzip

#Installing and setting up DNAS
WORKDIR /tmp

COPY --from=composer:2.7.8 /usr/bin/composer /usr/local/bin/composer
COPY --chown=www-data:www-data . /var/www/dnas
COPY ./docker/yy-log.conf /usr/local/etc/php-fpm.d/00-log.conf
COPY ./docker/openssl.cnf /usr/lib/ssl/openssl.cnf

WORKDIR /var/www/dnas

RUN composer install --no-interaction --optimize-autoloader --no-dev
RUN chown -R www-data:www-data .

USER www-data
EXPOSE 9000

CMD [ "php-fpm" ]