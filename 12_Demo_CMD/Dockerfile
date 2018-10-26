FROM centos

RUN yum install httpd -y

ADD startbootstrap-freelancer-gh-pages /var/www/html

ENV contenido prueba
RUN echo "$contenido"> /var/www/html/prueba.html

RUN echo "$(whoami)" > /var/www/html/user1.html

RUN useradd ricardo

USER ricardo

RUN echo "$(whoami)" > /tmp/user2.html

VOLUME /var/www/html

USER root

RUN cp /tmp/user2.html /var/www/html/user2.html

# Copia run sh dentro del container en la ubicación /run.sh
COPY run.sh /run.sh
# Ejecuta run.sh
CMD sh /run.sh

# Got to: 
# Localhost:80    o    http://localhost
# Localhost:80/prueba.html    o    http://localhost/prueba.html
# Localhost:80/user1.html    o    http://localhost/user1.html
# Localhost:80/user2.html    o    http://localhost/user2.html