# docker rmi $(docker images -q)
# docker logs apache-centos-user

FROM centos

RUN yum install httpd -y

ADD startbootstrap-freelancer-gh-pages /var/www/html

ENV contenido prueba
RUN echo "$contenido"> /var/www/html/prueba.html

# por defecto el usuario que realiza las tareas es `root`
RUN echo "$(whoami)" > /var/www/html/user1.html

# creamos un nuevo usuario `ricardo`
RUN useradd ricardo

# damos permisos a ricardo
RUN chown ricardo /var/www/html -R

# cambiamos de usuario a `ricardo`
USER ricardo

# incluimos el nombre del usuario en user2.html
RUN echo "$(whoami)" > /var/www/html/user2.html

CMD apachectl -DFOREGROUND

# `docker build --tag apache-centos:user .`
# construimos la imagen incluyendo un nuevo tag

# Nota no olvidar el punto final del comando 
# para referenciar el Docker file del directorio

# `docker images` para ver el listado de imagenes creadas

# `docker history -H apache-centos` para ver el historial 
# de capas del contenedor

# `docker run -d --name apache-centos-user -p 80:80 apache-centos:user` 
# para lanzar el contenedor en el puerto 80

# Got to: 
# Localhost:80    o    http://localhost
# Localhost:80/prueba.html    o    http://localhost/prueba.html

# matamos el contendor activo anterior `apache-centos`
# `docker rm -fv apache-centos-user`