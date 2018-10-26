FROM centos:7

# Capa de instalación
RUN \
    yum -y install \
    httpd \
    php-cli \
    php-common \
    # https apache centos
    # https://www.techrepublic.com/article/how-to-enable-https-on-apache-centos/
    mod_ssl \
    openssl
# Capa de Configuración
RUN echo "<?php phpinfo(); ?>" > /var/www/html/hola.php

COPY startbootstrap-freelancer-gh-pages /var/www/html

COPY ssl.conf /etc/httpd/conf.d/default.conf

COPY docker.crt /docker.crt
COPY docker.key /docker.key

# El puerto 443 está indicado dentro de ssl.conf
EXPOSE 443 

CMD apachectl -DFOREGROUND

# docker build --tag apache:ssl-ok .
# docker run -d -p 443:443 apache:ssl-ok