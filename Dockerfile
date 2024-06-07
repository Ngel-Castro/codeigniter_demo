# Use an official PHP runtime as a parent image
FROM php:8.0-apache

# Set the working directory
WORKDIR /var/www/html

# Copy the local files into the container
COPY . /var/www/html

# Install dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Install PHP extensions and Composer dependencies
RUN docker-php-ext-install pdo pdo_mysql && composer install

# Expose port 80
EXPOSE 80

# Start Apache in the foreground
CMD ["apache2-foreground"]