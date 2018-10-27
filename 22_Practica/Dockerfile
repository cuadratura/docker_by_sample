FROM debian:stable
 
RUN \
   apt-get update && \
   apt-get install -y \
        apache2 \ 
        wget \
        apt-transport-https \
        lsb-release \ 
        ca-certificates && \
   wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
   sh -c 'echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > \
        /etc/apt/sources.list.d/php.list' && \
   apt-get update && \
   apt-get install -y \
        php7.2 \
        php7.2-common \
        php7.2-cli \
        php7.2-fpm \
        php7.2-gd \
        php7.2-xml \
        php7.2-curl \
        php7.2-mbstring \
        libapache2-mod-php \
        php7.2-zip
 
LABEL version=2.0
LABEL description="Prueba de conceptos Curso de Docker. Apache + PHP en Debian"
LABEL vendor="Imagina Group"
                                                                                             
EXPOSE 80
 
COPY index.php /var/www/html/index.php
 
CMD apachectl -DFOREGROUND