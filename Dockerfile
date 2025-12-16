# Menggunakan base image Drupal 8
FROM drupal:8.9.20-php7.4-fpm-alpine3.13

# 1. Install library sistem yang dibutuhkan untuk ekstensi PHP
RUN apk add --no-cache \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    icu-dev \
    $PHPIZE_DEPS

# 2. Compile ekstensi PHP (GD, Opcache, Zip, Intl)
RUN docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) \
    gd \
    opcache \
    zip \
    intl \
    pdo_mysql

# 3. Copy file optimasi PHP ke dalam container
COPY ./config/php-drupal.ini /usr/local/etc/php/conf.d/00-drupal.ini

# 4. Set owner ke www-data agar Drupal bisa menulis file
RUN chown -R www-data:www-data /var/www/html

WORKDIR /var/www/html
