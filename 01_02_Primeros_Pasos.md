# Primeros Pasos

--------------------------------------------------------------------------

## Demo 1 - Centos

--------------------------------------------------------------------------

Crearemos un primer **DockerFile**, con el siguiente contenido.

(Source: [Install Apache Centos](https://www.google.com/search?client=ubuntu&hs=rCy&channel=fs&ei=vLbpW_qfCsGCapb7ntgE&q=install+apache+centos&oq=install+apache+centos&gs_l=psy-ab.3...1925.2543.0.2818.5.5.0.0.0.0.0.0..0.0....0...1c.1.64.psy-ab..5.0.0....0.wmuCac1WzQU) Result: [https://www.linode.com/docs/web-servers/apache/install-and-configure-apache-on-centos-7/](https://www.linode.com/docs/web-servers/apache/install-and-configure-apache-on-centos-7/))

_[DockerFile](./Dockerfile)_
```dockerfile
# Definimos el SO
FROM centos
# Instalamos apache para centos (S.O.)
RUN yum -y install httpd
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag <image-name> .`, en este caso usaremos `docker build --tag apache-centos .`.

> **Nota**: **NO OLVIDAR** el punto final del comando para referenciar el **Dockerfile** del directorio.

Ejecutaremos el comando `docker images` para ver el listado de imágenes creadas.


[Volver al inicio](#primeros-pasos)





--------------------------------------------------------------------------

## Demo 2 - Ubuntu

--------------------------------------------------------------------------

Crearemos un segundo **DockerFile**, con el siguiente contenido.

(Source: [Install Apache Centos](https://www.google.com/search?client=ubuntu&hs=cXd&channel=fs&ei=wLbpW8LJGOGUlwSO0IyQDg&q=install+apache+ubuntu&oq=install+apache+ubuntu&gs_l=psy-ab.3...366117.366941.0.367350.6.6.0.0.0.0.0.0..0.0....0...1c.1.64.psy-ab..6.0.0....0.sBSm1Rp2oQ8) Result: [https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-16-04](https://www.digitalocean.com/community/tutorials/how-to-install-the-apache-web-server-on-ubuntu-16-04))

_[DockerFile](./Dockerfile)_
```dockerfile
# Definimos el SO
FROM ubuntu:16.04
# Instalamos apache para centos (S.O.)
RUN apt-get update
RUN apt-get install apache2 -y
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag <image-name> .`, en este caso usaremos `docker build --tag apache-ubuntu .`.

> **Nota**: **NO OLVIDAR** el punto final del comando para referenciar el **Dockerfile** del directorio.

Ejecutaremos el comando `docker images` para ver el listado de imágenes creadas.


[Volver al inicio](#primeros-pasos)




--------------------------------------------------------------------------

## Demo 3 - COPY

--------------------------------------------------------------------------

Ahora trabajaremos con la Demo 1, a la que le añadiremos el comando COPY para incluir cierto contenido dentro de la imagen y un Comando **CMD**, `apachectl -DFOREGROUND` que ejecutará **apache** en primer plano.

_[DockerFile](./Dockerfile)_
```Dockerfile
# Definimos el SO
FROM centos
# Instalamos apache para centos (S.O.)
RUN yum install httpd -y
# Copiamos la carpeta en el contenedor
COPY beryllium /var/www/html
# Ejecutamos Apache en primer plano
CMD apachectl -DFOREGROUND
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag <image-name> .`, en este caso usaremos `docker build --tag apache-centos .`.

> **Nota**: **NO OLVIDAR** el punto final del comando para referenciar el **Dockerfile** del directorio.

Ejecutaremos el comando `docker images` para ver el listado de imágenes creadas.

```bash
$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
apache-centos       latest              719a76ddf1e6        9 seconds ago       335MB
<none>              <none>              7a77789eb8ae        16 minutes ago      333MB
centos              latest              75835a67d134        4 weeks ago         200MB
``` 

Si vemos el listado de imágenes observaremos que la imagen con **id** **7a77789eb8ae**, no dispone de repositorio, más adelante veremos que esa imagen se ha quedado huérfana.

**NUEVO** Ejecutaremos el comando `docker history -H apache-centos` para ver el historial de capas de la imagen.

```bash
$ docker history -H apache-centos
IMAGE               CREATED              CREATED BY                                      SIZE                COMMENT
719a76ddf1e6        About a minute ago   /bin/sh -c #(nop)  CMD ["/bin/sh" "-c" "apac…   0B
93ead608ce96        About a minute ago   /bin/sh -c #(nop) COPY dir:d3d885b1edbb91f70…   2.26MB
9e4d44d8bbbb        About a minute ago   /bin/sh -c yum install httpd -y                 132MB
75835a67d134        4 weeks ago          /bin/sh -c #(nop)  CMD ["/bin/bash"]            0B
<missing>           4 weeks ago          /bin/sh -c #(nop)  LABEL org.label-schema.sc…   0B
<missing>           4 weeks ago          /bin/sh -c #(nop) ADD file:fbe9badfd2790f074…   200MB
```

**NUEVO** Ejecutaremos el comando `docker run -d --name apache-centos -p 80:80 apache-centos` para lanzar el contenedor en el puerto 80. Ahora podremos acceder a [http://localhost:80]

```bash
$ docker run -d --name apache-centos -p 80:80 apache-centos
dc2f8f279ae00f7c1cb0efd0ac8620a0bf6077131de5657a18efe1fc5aff9f0e
```

```bash
$ docker ps
CONTAINER ID IMAGE         COMMAND                CREATED        STATUS        PORTS                NAMES
dc2f8f279ae0 apache-centos "/bin/sh -c 'apachec…" 21 seconds ago Up 19 seconds 0.0.0.0:80->80/tcp  apache-centos
```

[Volver al inicio](#primeros-pasos)




--------------------------------------------------------------------------

## Demo 4 - ADD

--------------------------------------------------------------------------

Ahora trabajaremos con la Demo 1, a la que le añadiremos el comando COPY para incluir cierto contenido dentro de la imagen y un Comando **CMD**, `apachectl -DFOREGROUND` que ejecutará **apache** en primer plano.

_[DockerFile](./Dockerfile)_
```dockerfile
# Definimos el SO
FROM centos
# Instalamos apache para centos (S.O.)
RUN yum install httpd -y
# Copiamos la carpeta en el contenedor
ADD startbootstrap-freelancer-gh-pages /var/www/html
# Ejecutamos Apache en primer plano
CMD apachectl -DFOREGROUND
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag <image-name> .`, en este caso usaremos `docker build --tag apache-centos .`.

> **Nota**: **NO OLVIDAR** el punto final del comando para referenciar el **Dockerfile** del directorio.

Ejecutaremos el comando `docker images` para ver el listado de imágenes creadas.

> **NOTA**: Ejecutaremos el comando `docker history -H apache-centos` para ver el historial de capas de la imagen.

**NUEVO** Ejecutaremos el comando `docker run -d --name apache-centos -p 80:80 apache-centos` para lanzar el contenedor en el puerto 80. 


```bash
$ docker run -d --name apache-centos -p 80:80 apache-centos
docker: Error response from daemon: Conflict. The container name "/apache-centos" is already in use by container "dc2f8f279ae00f7c1cb0efd0ac8620a0bf6077131de5657a18efe1fc5aff9f0e". You have to remove (or rename) that container to be able to reuse that name.
See 'docker run --help'.
```

**OJO HEMOS OBTENIDO UN ERROR,YA EXISTE UN CONTENENDOR CON ESE NOMBRE**, para solucionarlo eliminaremos el contenedor antiguo mediante el comando `docker rm -fv apache-centos`, **AHORA YA SI PODREMOS LANZAR EL COMANDO PARA MONTAR EL CONTENEDOR**, `docker run -d --name apache-centos -p 80:80 apache-centos`.

```bash
$ docker rm -fv apache-centos
apache-centos

$ docker run -d --name apache-centos -p 80:80 apache-centos
6aec713f286b686831a635e2745eaf1ebddda07b33405bf4888b80d5d2c53ce0
```

Ahora podremos acceder a [http://localhost:80]

**¿CuÁL ES LA DIFERENCIA ENTRE COPY Y ADD?** 
* **ADD** permite añadir url.
* **COPY** **NO** permite añadir url.

[Volver al inicio](#primeros-pasos)




--------------------------------------------------------------------------

## Demo 5 - ENV

--------------------------------------------------------------------------

La **instrucción** **ENV** permite la inclusión de variables dentro de la imagen.

```Dockerfile
# Definimos el SO
FROM centos
# Instalamos apache para centos (S.O.)
RUN yum install httpd -y
# ENV <variable-name> <variable-value>
ENV contenido prueba
# RUN echo incluye el valor de la variable dentro 
# del archivo indicado
RUN echo "$contenido"> /var/www/html/prueba.html
# Ejecutamos Apache en primer plano
CMD apachectl -DFOREGROUND
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag <image-name> .`, en este caso usaremos `docker build --tag apache-centos .`.

> **Nota**: **NO OLVIDAR** el punto final del comando para referenciar el **Dockerfile** del directorio.

Ejecutaremos el comando `docker images` para ver el listado de imágenes creadas.

> **NOTA**: Ejecutaremos el comando `docker history -H apache-centos` para ver el historial de capas de la imagen.

**OJO DEBEMOS ELIMINAR EL CONTENEDOR ANTERIOR QUE DISPONÍA DE ESE NOMBRE**, para eso ejecutaremos el comando `docker rm -fv apache-centos`, **AHORA YA SI PODREMOS LANZAR EL COMANDO PARA MONTAR EL CONTENEDOR**, `docker run -d --name apache-centos -p 80:80 apache-centos`.

```bash
$ docker rm -fv apache-centos
apache-centos

$ docker run -d --name apache-centos -p 80:80 apache-centos
6aec713f286b686831a635e2745eaf1ebddda07b33405bf4888b80d5d2c53ce0
```

Ahora podremos acceder a [http://localhost/prueba.html](http://localhost/prueba.html)

[Volver al inicio](#primeros-pasos)



--------------------------------------------------------------------------

## Demo 5 - WORKDIR

--------------------------------------------------------------------------

La **instrucción** **WORKDIR** define la ubicación de un directorio de trabajo dentro del contenedor, que será dónde se ubicarán los archivos que copiemos.

```diff
# Definimos el SO
FROM centos
# Instalamos apache para centos (S.O.)
RUN yum install httpd -y
# ENV <variable-name> <variable-value>
ENV contenido prueba
# Incluimos el directorio de trabajo del contenedor
++ WORKDIR /var/www/html
# RUN echo incluye el valor de la variable dentro 
# del archivo indicado
-- RUN echo "$contenido"> /var/www/html/prueba.html
++ RUN echo "$contenido"> prueba.html
# Ejecutamos Apache en primer plano
CMD apachectl -DFOREGROUND
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag <image-name> .`, en este caso usaremos `docker build --tag apache-centos:workdir .`.

> **Nota**: **NO OLVIDAR** el punto final del comando para referenciar el **Dockerfile** del directorio.

Ejecutaremos el comando `docker images` para ver el listado de imágenes creadas.

Ejecutaremos el comando `docker run -d --name apache-centos-workdir -p 80:80 apache-centos:workdir`.

> **ELIMINAR CONTENEDOR FORZADO**, `docker rm -fv <container-name>`.

Ahora podremos acceder a [http://localhost/prueba.html](http://localhost/prueba.html)

[Volver al inicio](#primeros-pasos)



--------------------------------------------------------------------------

## Demo 6 - EXPOSE

--------------------------------------------------------------------------

* `docker rm -fv $(docker ps -aq)`, elimina todos los contenedores.
* `docker rmi $(docker images -q)`, elimina todas las imágenes existentes.

La **instrucción** **EXPOSE** informa al Docker que el contenedor escucha en los puertos de red especificados en tiempo de ejecución. Puede especificar si el puerto escucha en TCP o UDP, y el valor predeterminado es TCP si el protocolo no está especificado.

```dockerfile
# Definimos el SO
FROM centos

# Instalamos apache para centos (S.O.)
RUN yum install httpd -y

EXPOSE 8080
# expone el puerto 8080 del contenedor

# Ejecutamos Apache en primer plano
CMD apachectl -DFOREGROUND
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag <image-name> .`, en este caso usaremos `docker build --tag apache-centos:expose .`.

> **Nota**: **NO OLVIDAR** el punto final del comando para referenciar el **Dockerfile** del directorio.

Ejecutaremos el comando `docker images` para ver el listado de imágenes creadas.

Ejecutaremos el comando `docker run -d --name apache-centos-expose -p 80:80 apache-centos:expose`.

[Volver al inicio](#primeros-pasos)



--------------------------------------------------------------------------

## Demo 7 - LABEL

--------------------------------------------------------------------------

* `docker rm -fv $(docker ps -aq)`, elimina todos los contenedores.
* `docker rm -fv <container-name>`, elimina el contenedor indicado.
* `docker rmi $(docker images -q)`, elimina todas las imágenes existentes.
* `docker rmi -<image-name>`, elimina la imagen indicada.

El **atributo** **LABEL** aporta información extra a la imagen, son unas etiquetas que ya están definidas.

```dockerfile
FROM centos
# Incluimos la etiqueta que indique la 
# versión del contenedor
LABEL version=1.0
# Incluimos la etiqueta descripción
LABEL description="This is an apache image"
# Incluimos la etiqueta vendor
LABEL vendor="ImaginaFormacion"
RUN yum install httpd -y
CMD apachectl -DFOREGROUND
```

[Volver al inicio](#primeros-pasos)




--------------------------------------------------------------------------

## Demo 8 - USER FAIL

--------------------------------------------------------------------------

* `docker rm -fv $(docker ps -aq)`, elimina todos los contenedores.
* `docker rm -fv <container-name>`, elimina el contenedor indicado.
* `docker rmi $(docker images -q)`, elimina todas las imágenes existentes.
* `docker rmi -<image-name>`, elimina la imagen indicada.

**NOTA** Esta demo fallará por razones de permisos dentro del propio contenedor.

```dockerfile
FROM centos
RUN yum install httpd -y
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
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag <image-name> .`, en este caso usaremos `docker build --tag apache-centos:userfail .`.

> **Nota**: **NO OLVIDAR** el punto final del comando para referenciar el **Dockerfile** del directorio.

Ejecutaremos el comando `docker images` para ver el listado de imágenes creadas.

Ejecutaremos el comando `docker run -d --name apache-centos-userfail -p 80:80 apache-centos:userfail`.

Ahora podremos acceder a [http://localhost/user2.html](http://localhost/user2.html)

**UPSSS FALLA**, veamos que pasó... `docker logs apache-centos-usefail`

[Volver al inicio](#primeros-pasos)




--------------------------------------------------------------------------

## Demo 9 - USER

--------------------------------------------------------------------------

* `docker rm -fv $(docker ps -aq)`, elimina todos los contenedores.
* `docker rm -fv <container-name>`, elimina el contenedor indicado.
* `docker rmi $(docker images -q)`, elimina todas las imágenes existentes.
* `docker rmi -<image-name>`, elimina la imagen indicada.

```dockerfile
FROM centos
RUN yum install httpd -y
# por defecto el usuario que realiza las tareas es `root`
RUN echo "$(whoami)" > /var/www/html/user1.html
# creamos un nuevo usuario `ricardo`
RUN useradd ricardo
# cambiamos de usuario a `ricardo`
USER ricardo
# incluimos el nombre del usuario en user2.html
RUN echo "$(whoami)" > /tmp/user2.html
# cambiamos de usuario a `root`
USER root
# root copia el archivo en la nueva ruta
RUN cp /tmp/user2.html /var/www/html/user2.html
CMD apachectl -DFOREGROUND
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag <image-name> .`, en este caso usaremos `docker build --tag apache-centos:user .`.

> **Nota**: **NO OLVIDAR** el punto final del comando para referenciar el **Dockerfile** del directorio.

Ejecutaremos el comando `docker images` para ver el listado de imágenes creadas.

Ejecutaremos el comando `docker run -d --name apache-centos-user -p 80:80 apache-centos:user`.

Ahora podremos acceder a [http://localhost/user2.html](http://localhost/user2.html)

[Volver al inicio](#primeros-pasos)





--------------------------------------------------------------------------

## Demo 10 - VOLUMES

--------------------------------------------------------------------------

* `docker rm -fv $(docker ps -aq)`, elimina todos los contenedores.
* `docker rm -fv <container-name>`, elimina el contenedor indicado.
* `docker rmi $(docker images -q)`, elimina todas las imágenes existentes.
* `docker rmi -<image-name>`, elimina la imagen indicada.

**Esto lo veremos en más profundida posteriormente. Su finalidad es que las modificaciones que se realicen dentro de esa ubicación en el contenedor no desaparezcan cuando el contenedor muera. (ejemplo base de datos)**

```Dockerfile
FROM centos
RUN yum install httpd -y
RUN echo "$(whoami)" > /var/www/html/user1.html
RUN useradd ricardo
USER ricardo
RUN echo "$(whoami)" > /tmp/user2.html
# Persiste el contenedor generado en esa ruta
VOLUME /var/www/html
USER root
RUN cp /tmp/user2.html /var/www/html/user2.html
CMD apachectl -DFOREGROUND
```

Ahora podremos acceder a [http://localhost/user2.html](http://localhost/user2.html)

[Volver al inicio](#primeros-pasos)



--------------------------------------------------------------------------

## Demo 11 - CMD

--------------------------------------------------------------------------

* `docker rm -fv $(docker ps -aq)`, elimina todos los contenedores.
* `docker rm -fv <container-name>`, elimina el contenedor indicado.
* `docker rmi $(docker images -q)`, elimina todas las imágenes existentes.
* `docker rmi -<image-name>`, elimina la imagen indicada.

Veremos como usar la instrucción **CMD**.

```Dockerfile
FROM centos
RUN yum install httpd -y
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
```

```sh
# !/bin/bash
echo "Inciando container...."
# una vez lanzado el contenedor podremos acceder a localhost:81/ para ver el resultado
echo "INICIADO!!" > /var/www/html/ini.html

apachectl -DFOREGROUND
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag <image-name> .`, en este caso usaremos `docker build --tag apache-centos:cmd .`.

Ejecutaremos el comando `docker run -d --name apache-centos-cmd -p 81:80 apache-centos:cmd`.

Ahora podremos acceder a [http://localhost:81/ini.html](http://localhost:81/ini.html)

[Volver al inicio](#primeros-pasos)



--------------------------------------------------------------------------

## Demo 12 - DOCKERIGNORE 

--------------------------------------------------------------------------

Cuando ejecutamos el comando constructor de imágenes, `docker build --tag <image-name> .`, docker envía todo el contenido de la carpeta al constructor, con **Docker ignore** evitamos que envíe archivos innecesarios.

[Volver al inicio](#primeros-pasos)



--------------------------------------------------------------------------

## Demo 13 - IMAGEN CON TODOS LOS ARGUMENTOS POSIBLES

--------------------------------------------------------------------------

* `docker rm -fv $(docker ps -aq)`, elimina todos los contenedores.
* `docker rm -fv <container-name>`, elimina el contenedor indicado.
* `docker rmi $(docker images -q)`, elimina todas las imágenes existentes.
* `docker rmi -<image-name>`, elimina la imagen indicada.

En este ejmplo crearemos una imagen con todos los argumentos posibles que hemos visto hasta el momento.

```dockerfile
FROM nginx
RUN useradd ricardo
# /usr/share/nginx/html ubicación de lectura en nginx (https://hub.docker.com/_/nginx/)
COPY fruit /usr/share/nginx/html
ENV archivo docker
WORKDIR /usr/share/nginx/html
RUN echo "$archivo" > /usr/share/nginx/html/env.html
EXPOSE 90
LABEL version=1
USER ricardo
RUN echo "Yo soy $(whoami)" > /tmp/yo.html
USER root
RUN cp /tmp/yo.html /usr/share/nginx/html/docker.html
VOLUME /var/log/mginx
# podemos dejar el cmd en blanco ya que cogerá en CMD de nginx
CMD nginx -g 'daemon off;'
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag <image-name> .`, en este caso usaremos `docker build --tag nginx:all .`.

Ejecutaremos el comando `docker run -d --name nginx-all -p 81:80 nginx:all`.

[Volver al inicio](#primeros-pasos)



--------------------------------------------------------------------------

## Demo 14 - BUENAS PRÁCTICAS

--------------------------------------------------------------------------

* `docker rm -fv $(docker ps -aq)`, elimina todos los contenedores.
* `docker rm -fv <container-name>`, elimina el contenedor indicado.
* `docker rmi $(docker images -q)`, elimina todas las imágenes existentes.
* `docker rmi -<image-name>`, elimina la imagen indicada.

Ahora veremos una serie de buenas prácticas a utilizar, consistente en la forma de escribir el código y encadenarlo.

```DockerFile
FROM nginx

# LABEL version=1
# RUN echo "1" >> /usr/share/nginx/html/test.txt
# RUN echo "2" >> /usr/share/nginx/html/test.txt
# RUN echo "3" >> /usr/share/nginx/html/test.txt

LABEL version=2
RUN \
    echo "1" >> /usr/share/nginx/html/test.txt && \
    echo "2" >> /usr/share/nginx/html/test.txt && \
    echo "3" >> /usr/share/nginx/html/test.txt
```


[Volver al inicio](#primeros-pasos)



--------------------------------------------------------------------------

## Demo 15 - EJEMPLO MÁS COMPLEJO

--------------------------------------------------------------------------

* `docker rm -fv $(docker ps -aq)`, elimina todos los contenedores.
* `docker rm -fv <container-name>`, elimina el contenedor indicado.
* `docker rmi $(docker images -q)`, elimina todas las imágenes existentes.
* `docker rmi -<image-name>`, elimina la imagen indicada.

Ahora veremos un ejemplo algo más complejo.

```dockerfile
FROM centos:7
# Capa de instalación
RUN \
    # instalamos apache
    yum -y install \
    httpd \
    # isntalamos php
    php-cli \
    php-common
# Capa de Configuración
RUN echo "<?php phpinfo(); ?>" > /var/www/html/hola.php

CMD apachectl -DFOREGROUND
```

Para ejecutarlo, dentro de la carpeta del proyecto ejecutaremos el comando `docker build --tag centos:php .`.

Ejecutaremos el comando `docker run -d --name centos-php -p 81:80 centos:php`.

```diff
FROM centos:7
# Capa de instalación
RUN \
    # instalamos apache
    yum -y install \
    httpd \
    # isntalamos php
    php-cli \
    php-common
# Capa de Configuración
RUN echo "<?php phpinfo(); ?>" > /var/www/html/hola.php
++ COPY startbootstrap-freelancer-gh-pages /var/www/html
CMD apachectl -DFOREGROUND
```

Ejecutamos el comando `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout docker.key -out docker.ctr`

```diff
FROM centos:7
# Capa de instalación
RUN \
    # instalamos apache
    yum -y install \
    httpd \
    # isntalamos php
    php-cli \
--  php-common
++  php-common \
++  # instalamos el https apache centos
++  # https://www.techrepublic.com/article/how-to-enable-https-on-apache-centos/
++  mod_ssl \
++  openssl
# Capa de Configuración
RUN echo "<?php phpinfo(); ?>" > /var/www/html/hola.php
COPY startbootstrap-freelancer-gh-pages /var/www/html
++ COPY ssl.conf /etc/httpd/conf.d/default.conf
++ COPY docker.crt /docker.crt
++ COPY docker.key /docker.key
++ # El puerto 443 está indicado dentro de ssl.conf
++ EXPOSE 443 
CMD apachectl -DFOREGROUND
```

Ejecutaremos el comando, `docker build --tag apache:ssl-ok .`y construiremos el contenedor con el comando `docker run -d -p 443:443 apache:ssl-ok`.