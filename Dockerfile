# Use the official Ubuntu base image
FROM ubuntu:latest

# Set environment variables to prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update and install required packages
RUN apt-get update && apt-get install -y \
    software-properties-common \
    lsb-release \
    curl \
    wget \
    zip \
    unzip \
    git \
    build-essential \
    php-dev \
    php-pear \
    && add-apt-repository ppa:ondrej/php -y \
    && apt-get update

# Install PHP and necessary extensions
RUN apt-get install -y \
    php \
    php-cli \
    php-common \
    php-curl \
    php-xml \
    php-mbstring \
    php-zip

# Install Redis server
RUN apt-get install -y redis-server

# Install the phpredis extension using pecl
RUN pecl install redis && echo "extension=redis.so" > /etc/php/$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")/cli/conf.d/20-redis.ini

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set the working directory
WORKDIR /data
