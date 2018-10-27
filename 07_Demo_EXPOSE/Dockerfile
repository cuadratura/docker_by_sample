# Definimos el SO
FROM centos

# Instalamos apache para centos (S.O.)
RUN yum install httpd -y

WORKDIR /var/www/html

# Copiamos la carpeta en el contenedor
ADD startbootstrap-freelancer-gh-pages .

# ENV <variable-name> <variable-value>
ENV contenido prueba
# RUN echo incluye el valor de la variable dentro 
# del archivo indicado
RUN echo "$contenido"> prueba.html

EXPOSE 8080
# expone el puerto 8080 del contenedor

# Ejecutamos Apache en primer plano
CMD apachectl -DFOREGROUND