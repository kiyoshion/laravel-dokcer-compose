FROM php:8.2-fpm

ENV TZ=UTC \
    LANG=en_US.UTF-8 \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8

RUN apt-get update && \
    apt-get install -y vim gcc g++ make git unzip libzip-dev libicu-dev libonig-dev libpng-dev libjpeg-dev && \
    docker-php-ext-configure gd --with-jpeg  &&\
    docker-php-ext-install -j$(nproc) gd &&\
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    docker-php-ext-install intl pdo_mysql zip bcmath

RUN curl -sL https://deb.nodesource.com/setup_18.x -o nodesource_setup.sh && \
    bash nodesource_setup.sh && \
    apt-get install -y nodejs

COPY ./docker/app/php.ini /usr/local/etc/php/php.ini

COPY --from=composer /usr/bin/composer /usr/bin/composer

WORKDIR /app
