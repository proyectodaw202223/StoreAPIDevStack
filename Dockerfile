FROM ubuntu:22.04

# Copy entrypoint script to /
COPY ./docker-entrypoint.sh /

RUN chmod +x /docker-entrypoint.sh

RUN apt update

# Install git, php and laravel dependencies
RUN DEBIAN_FRONTEND=noninteractive apt install -qq -y \
git php openssl php-common php-curl php-json php-mbstring php-mysql php-xml php-zip

# Install composer from official guide: https://getcomposer.org/download/
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php -r "if (hash_file('sha384', 'composer-setup.php') === '55ce33d7678c5a611085589f1f3ddf8b3c52d662cd01d4ba75c0ee0459970c2200a51f492d557530c71c15d8dba01eae') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

# Install laravel
RUN composer global require laravel/installer

# Add the directory /.composer/vendor/bin/ to the PATH on startup.
RUN echo "export PATH=~/.composer/vendor/bin/:$PATH" >> ~/.bashrc

# Create Laravel proyect
RUN composer create-project --prefer-dist laravel/laravel StoreAPI-bkp

WORKDIR /StoreAPI-bkp

# Delete laravel default migrations and Models
RUN rm -f database/migrations/*
RUN rm -f app/Models/*

# Init repository with latest commits from GitHub
RUN git init
RUN git remote add origin https://github.com/proyectodaw202223/StoreAPI
RUN git fetch --all
RUN git reset --hard origin/master

RUN mkdir ../StoreAPI
WORKDIR /StoreAPI

CMD ["/docker-entrypoint.sh"]
