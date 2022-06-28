FROM php:7.4-cli

COPY app/lib/90-xdebug.ini "${PHP_INI_DIR}/conf.d"
RUN pecl install xdebug
RUN docker-php-ext-enable xdebug

# # Mudar para o diretória raíz
WORKDIR /app

# Atualizar os pacotes da imagem
RUN apt update

# Instalar PDO e pdo_mysql
RUN docker-php-ext-install mysqli pdo pdo_mysql

RUN apt install -y git libzip-dev 
# Instalar dependências mcrypt, zip, unzip, etc
RUN apt-get update && apt-get install -y \
    libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        mcrypt \
        zip \
        unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg 

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Configurar LDAP.
RUN apt-get update \
 && apt-get install libldap2-dev -y \
 && rm -rf /var/lib/apt/lists/* \
 && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu/ \
 && docker-php-ext-install ldap

# Instalar gd
RUN docker-php-ext-install gd

# Instalar imap
RUN apt update && apt install -y libc-client-dev libkrb5-dev && rm -r /var/lib/apt/
RUN docker-php-ext-configure imap --with-kerberos --with-imap-ssl && docker-php-ext-install imap

