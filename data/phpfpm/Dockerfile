FROM php:7.2-fpm
RUN apt-get update \
    && apt-get upgrade -y
RUN apt-get install -y --no-install-recommends \
    supervisor \
    git \
    unzip \
    libzip-dev \
    zlib1g-dev \
    curl \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    libxslt-dev \
    libxml2-dev
RUN docker-php-ext-install \
    zip \
    bcmath \
    pdo_mysql \
    mysqli \
    mbstring \
    opcache \
    intl \
    xsl \
    soap
RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
    && docker-php-ext-install -j$(nproc) gd

RUN apt-get update \
  && apt-get install -my wget gnupg

RUN curl -sS https://getcomposer.org/installer -o composer-setup.php
RUN php composer-setup.php --install-dir=/usr/local/bin --filename=composer
ADD php.ini /usr/local/etc/php/php.ini
##
## blackfire.io
##
ARG BLACKFIRE_SERVER_ID
ARG BLACKFIRE_SERVER_TOKEN
ARG BLACKFIRE_CLIENT_ID
ARG BLACKFIRE_CLIENT_TOKEN
RUN wget -q -O - https://packages.blackfire.io/gpg.key | apt-key add -
RUN echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list
RUN apt-get update
RUN apt-get install -y blackfire-agent
RUN blackfire-agent --register --server-id=${BLACKFIRE_SERVER_ID} --server-token=${BLACKFIRE_SERVER_TOKEN}
RUN apt-get install -y blackfire-php
RUN blackfire config --client-id=${BLACKFIRE_CLIENT_ID} --client-token=${BLACKFIRE_CLIENT_TOKEN}
#
# Supervisor
#
ADD supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /usr/local/bin
RUN  chmod 755 /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
#CMD ["/usr/bin/supervisord", "-n", "-c",  "/etc/supervisord.conf"]
