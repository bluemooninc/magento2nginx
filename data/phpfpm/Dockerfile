FROM php:7.3-fpm-alpine
LABEL maintainer="Y.Sakai @ Bluemoon inc."

ADD     http://downloads3.ioncube.com/loader_downloads/ioncube_loaders_lin_x86-64.tar.gz /tmp/

RUN     apk update                       && \
        \
        apk upgrade                      && \
        \
        docker-php-source extract        && \
        \
        apk add --no-cache                  \
            --virtual .build-dependencies   \
                $PHPIZE_DEPS                \
                zlib-dev                    \
                cyrus-sasl-dev              \
                git                         \
                autoconf                    \
                g++                         \
                libtool                     \
                make                        \
                automake                    \
                pcre-dev                 && \
        \
        apk add --no-cache                  \
            gettext                         \
            tini                            \
            libintl                         \
            icu                             \
            icu-dev                         \
            libxml2-dev                     \
            php-soap                        \
            freetype-dev                    \
            libjpeg-turbo-dev               \
            libpng-dev                      \
            gmp                             \
            gmp-dev                         \
            libmemcached-dev                \
            imagemagick-dev                 \
            libssh2                         \
            libssh2-dev                     \
            libxslt-dev                     \
            zip                             \
            libzip-dev                      \
            unzip
#
# comment out 12/31/2019
#   apk add --no-cache icu-l\
#
RUN set -x && \
  apk add --no-cache --virtual build-dependencies && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ && \
  docker-php-ext-install -j${NPROC} intl && \
  docker-php-ext-install -j${NPROC} mysqli && \
  docker-php-ext-install -j${NPROC} pdo_mysql && \
  docker-php-ext-install -j${NPROC} pdo && \
  docker-php-ext-install -j${NPROC} mbstring && \
  docker-php-ext-install -j${NPROC} bcmath && \
  docker-php-ext-install -j${NPROC} gd && \
  docker-php-ext-install -j${NPROC} xml && \
  docker-php-ext-install -j${NPROC} soap && \
  docker-php-ext-install -j${NPROC} xsl && \
  docker-php-ext-install -j${NPROC} zip && \
  apk del --no-cache --purge build-dependencies && \
  rm -rf /tmp/pear

## For mail catcher
RUN apk --no-cache --update add \
    libstdc++ \
    build-base \
    openssl-dev \
    sqlite \
    sqlite-dev \
    ruby-rdoc \
    ruby-dev && \
    gem install mailcatcher -N

## copy php.ini
ADD php.ini /usr/local/etc/php/php.ini

RUN chmod -R 777 /var/www/html

## set user
RUN set -x && \
  deluser www-data && \
  addgroup -g 50 -S www-data && \
  adduser -u 1000 -D -S -G www-data www-data
VOLUME /etc/tnsnames.ora
