FROM php:8.3-fpm-alpine

USER root

COPY php.ini /usr/local/etc/php/php.ini

RUN apk update && apk add --no-cache \
    build-base \
    zlib-dev \
    unzip \
    curl \
    libzip-dev \
    nano \
    imagemagick-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    freetype-dev \
    openssl-dev \
    oniguruma-dev \
    libtool

RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd pdo pdo_mysql mbstring exif bcmath zip

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

RUN addgroup -g 1000 www
RUN adduser -u 1000 -G www -D www

RUN mkdir -p /var/www/backend

WORKDIR /var/www/backend

COPY ./src .

RUN chown -R www:www .

USER www

RUN composer install --optimize-autoloader

CMD ["php-fpm"]

EXPOSE 9000