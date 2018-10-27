FROM centos

# Incluimos la etiqueta que indique la 
# versión del contenedor
LABEL version=1.0
# Incluimos la etiqueta descripción
LABEL description="This is an apache image"
# Incluimos la etiqueta vendor
LABEL vendor="ImaginaFormacion"

RUN yum install httpd -y

WORKDIR /var/www/html

ADD startbootstrap-freelancer-gh-pages .

ENV contenido prueba

RUN echo "$contenido"> prueba.html

EXPOSE 8080

CMD apachectl -DFOREGROUND