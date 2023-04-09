FROM php:8.2-cli-buster
ARG WITH_XDEBUG=false
COPY --from=gebler/roadrunner-binary:latest /roadrunner/roadrunner/rr /usr/local/bin/rr
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apt-get update && apt-get install -y \
    libzip-dev \
    zip \
    unzip \
    openssl \
    && docker-php-ext-install zip && docker-php-ext-install sockets
RUN if [ "$WITH_XDEBUG" = "true" ]; then \
    pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.start_with_request=yes" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.client_port=9003" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini ; fi

RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

WORKDIR /app
COPY composer.json composer.json
RUN useradd -ms /bin/bash app && chown -R app:app /app
USER app

RUN composer install

ENTRYPOINT ["rr", "serve", "--config", "/app/.rr.yaml"]
