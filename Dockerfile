FROM php:7.2-apache-stretch

RUN apt-get update && apt-get install -y \
    git \
    zlib1g-dev \
    unzip

RUN git clone --depth=1 "git://github.com/phalcon/cphalcon.git" \
    && cd cphalcon/build \
    && ./install

RUN curl -sS https://getcomposer.org/installer | php  \
    && mv composer.phar /usr/local/bin/composer

RUN a2enmod rewrite

RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/4.1.1.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
    && docker-php-ext-install redis

RUN docker-php-ext-install -j$(nproc) pdo_mysql \
    && docker-php-ext-install -j$(nproc) zip

COPY php.ini /usr/local/etc/php/