ARG PHP_VERSION=8.2
ARG COMPOSER_VERSION=2

FROM composer:${COMPOSER_VERSION} as composer
FROM mlocati/php-extension-installer:latest as php-ext-installer
FROM php:${PHP_VERSION}-cli-alpine as php

COPY --from=composer --link /usr/bin/composer /usr/bin/composer
COPY --from=php-ext-installer --link /usr/bin/install-php-extensions /usr/local/bin/

ARG PHP_EXTENSIONS
RUN if [[ "$PHP_EXTENSIONS" != "" ]]; then set -eux && install-php-extensions $PHP_EXTENSIONS; fi

ARG SYMFONY=0
RUN if [[ $SYMFONY -eq 1 ]]; then \
    set -eux \
      && apk add --no-cache bash curl \
      && curl -1sLf 'https://dl.cloudsmith.io/public/symfony/stable/setup.alpine.sh' | bash \
      && apk add --no-cache symfony-cli; \
  fi

ARG GIT=0
RUN if [[ $GIT -eq 1 ]]; then apk add --no-cache git; fi

ARG UID=1000
ARG GID=1000
RUN chown -R "$UID:$GID" /home/www-data

WORKDIR /app
