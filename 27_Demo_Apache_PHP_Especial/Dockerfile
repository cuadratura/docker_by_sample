FROM centos:7

RUN \
    yum -y install \
    httpd \
    php-cli \
    php-common \

ENV ENV dev
ENV VIRTUALIZATION docker

CMD apachectl -DFOREGROUND
