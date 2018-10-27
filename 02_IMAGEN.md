
--------------------------------------------------------------------------

### Eliminar Imágenes

--------------------------------------------------------------------------

Para eliminar Imágenes existen distintas opciones: `docker rmi <image-name>:<image-tag>` o `docker rmi <image-id>`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker images | grep apache

apache-php-tls-ssl     latest              0300eedbad44        19 hours ago        360MB
apache                 ssl-ok              0300eedbad44        19 hours ago        360MB
apache-cento-ignores   latest              70350adbd1a5        21 hours ago        347MB
```

Así, ejecutaremos el comando `docker rmi apache-php-tls-ssl:latest` para eliminar la imagen con nombre y tags `apache-php-tls-ssl:latest`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker rmi apache-php-tls-ssl:latest
demo@VirtualBox:~/Demo_Docker$ docker images | grep apache

apache                 ssl-ok              0300eedbad44        19 hours ago        360MB
apache-cento-ignores   latest              70350adbd1a5        21 hours ago        347MB
```

Si ahora ejecutamos el comando `docker rmi 70350adbd1a5` se eliminará la imagen con id `70350adbd1a5`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker rmi 70350adbd1a5
demo@VirtualBox:~/Demo_Docker$ docker images | grep apache

apache                 ssl-ok              0300eedbad44        19 hours ago        360MB
apache-cento-ignores   latest              70350adbd1a5        21 hours ago        347MB
```

Puede ser que nos encontremos el siguiente mensaje al intentar eliminar una imagen: `Error response from daemon: conflict: unable to delete 0300eedbad44 (must be forced) - image is being used by stopped container bfb973bc90c5`, ello implicará que previamente es necesario para el contenedor en marcha, ya que dicha imagen está en uso por algún contenedor.


--------------------------------------------------------------------------

### Construir una imagen alternativa a DokerFile

--------------------------------------------------------------------------

Puede ocurrir, que por alguna razón necesitemos usar un dockerfile con un nombre alternativo, no estándar. Para ello ejecutaremos el siguiente comando `docker build -t <image-name>:<image-tag> -f <new-dockerfile-name> <location>,` siendo `<new-dockerfile-name>` el nombre del archivo incluida la ubicación del nuevo **Dockerfile**.

```bash
demo@VirtualBox:~/Demo_Docker$ ll
total 12
drwxrwxr-x  2 hector hector 4096 Oct 26 16:59 ./
drwxr-xr-x 19 hector hector 4096 Oct 26 16:58 ../
-rw-rw-r--  1 hector hector   22 Oct 26 16:59 my-dockkerfile
```

En este caso nuestro nuevo **Dockerfile**, se llamará **my-dockerfile**, y para construir la nueva imagen usaremos `docker build -t centos:hello -f my-dockerfile .`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker build -t centos:hello -f my-dockerfile .
```


--------------------------------------------------------------------------

### Imagenes huerfanas (Dangling Images)

--------------------------------------------------------------------------

Para entender esta situación primeramente la generaremos. Así, creamos una nueva imagen inicial sobre la que trabajar.

```dockerfile
FROM centos

RUN \
    echo "hola" > /tmp/hola && \
    echo "hola" >> /tmp/hola1

RUN echo "bye" > /tmp/bye  
 
RUN echo "test" > /tmp/test   
```

y la construimos con el comando ya visto `docker build --tag dangling-image .`.

```bash 
demo@VirtualBox:~/Demo_Docker$ docker build --tag dangling-image .
Sending build context to Docker daemon  2.048kB
Step 1/4 : FROM centos
 ---> 75835a67d134
Step 2/4 : RUN     echo "hola" > /tmp/hola &&     echo "hola" >> /tmp/hola1
 ---> Running in 6a3f4500ebb6
Removing intermediate container 6a3f4500ebb6
 ---> b15fd21c0cf0
Step 3/4 : RUN echo "bye" > /tmp/bye
 ---> Running in b1a0263b0805
Removing intermediate container b1a0263b0805
 ---> e43c03b66276
Step 4/4 : RUN echo "test" > /tmp/test
 ---> Running in f304f7e4ff09
Removing intermediate container f304f7e4ff09
 ---> afbe90498ce1
Successfully built afbe90498ce1
Successfully tagged dangling-image:latest
```
Ahora modificamos nuestro **dockerfile** en alguna de sus capas para regenerar la imagen. 

```diff
FROM centos

RUN \
    echo "hola" > /tmp/hola && \
    echo "hola" >> /tmp/hola1

-- RUN echo "bye" > /tmp/bye  
++ RUN echo "bye" > /tmp/bye1
 
RUN echo "test" > /tmp/test   
```

Y volvemos a regenerar la imagen con el mismo comando anterior para mantener el nombre de la imagen `docker build --tag dangling-image .`
 
```bash
demo@VirtualBox:~/Demo_Docker$ docker build --tag dangling-image .
Sending build context to Docker daemon  2.048kB
Step 1/4 : FROM centos
 ---> 75835a67d134
Step 2/4 : RUN     echo "hola" > /tmp/hola &&     echo "hola" >> /tmp/hola1
 ---> Using cache
 ---> b15fd21c0cf0
Step 3/4 : RUN echo "bye" > /tmp/bye1
 ---> Running in 01e0245a496e
Removing intermediate container 01e0245a496e
 ---> c8136ddf034c
Step 4/4 : RUN echo "test" > /tmp/test
 ---> Running in 4286f5cb2398
Removing intermediate container 4286f5cb2398
 ---> e40a2c6f5ece
Successfully built e40a2c6f5ece
Successfully tagged dangling-image:latest 
```

Veremos que hay parte de la construcción de la imagen que no usa cache, generando una imagen totalmente nueva.

Si ahora usamos el comando que muestre las imágenes `docker images`, veremos dos imágenes una de ellas no referenciadas o huerfana `<none>:

```bash
demo@VirtualBox:~/Demo_Docker$ docker images
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
dangling-image      latest              e40a2c6f5ece        3 minutes ago       200MB
<none>              <none>              afbe90498ce1        6 minutes ago      200MB
```

Si repitiésemos la jugada, aparecería una nueva imagen no referenciada.

> *¿Por qué al recrear una nueva imagen con el mismo tag deja huerfana a la anterior existente?* Esto ocurre ya que las capas son de sólo lectura y cada vez que se modifica una capa se genera una nueva imagen, colocando el nombre definido, pero si ya existía una imagen con ese nombre la dejará huerfana `<none>`. Por ello se recomienda usar *tags* para ir versionando las imágenes.


#### ¿Cómo podrías recuperar un listado de las imágenes huerfanas?

Usaremos el comando `docker images -f <tilter>=true`, por ejemplo en este caso usaríamos `docker images -f dangling=true`. Veríamos un resultado así:

```bash
demo@VirtualBox:~/Demo_Docker$ docker images -f dangling=true
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
<none>              <none>              afbe90498ce1        15 minutes ago      200MB
<none>              <none>              83c744d58330        21 hours ago        110MB
<none>              <none>              fa4ffeea341f        21 hours ago        110MB
<none>              <none>              443a09182ebc        21 hours ago        110MB
<none>              <none>              a21ca6cb79a6        22 hours ago        347MB
<none>              <none>              dd9c20b32f32        23 hours ago        347MB
```

De aquí podríamos coger los *id* de cada imagen para detectarlas.

Si quisieramos eliminarlas todas, podríamos hacerlo individualmente con lel comando `docker rmi <image-id>`, o para optimizar usar:

`docker images -f dangling=true -q | xargs docker rmi`

El atributo `-q` mostaría sólo los *id* de las imágenes filtradas, y mediante el comando de linux `| xargs` concatenaremos un nuevo comando (para eliminar imágenes) con el listado obtenido.

```bash
demo@VirtualBox:~/Demo_Docker$ docker images -f dangling=true -q | xargs docker rmi
Deleted: sha256:afbe90498ce1c93bda311f0191f330edc8d10902e08e7f3fb163ca512056ed4e
Deleted: sha256:f993535193392cff70274d1c4e5786855a3528f39f4c50cb16b0919fa72a8a99
Deleted: sha256:e43c03b66276d8bef7190f8ef2779f1faf53876eab7129f219c953de3c0ae1f2
Deleted: sha256:7a50a8816d27a73a2a2ea4e8e60d3bf1496585498a9b4e7e17e4e9c31d115b23
```

> Nota: Es importante haber parado todos los contenedores vivos vinculados, ya que si la imagen sigue en uso no podrá ser eliminada.

```bash
demo@VirtualBox:~/Demo_Docker$ docker images -f dangling=true
REPOSITORY          TAG                 IMAGE ID            CREATED             SIZE
```


--------------------------------------------------------------------------

### Demo Nginx PHP y FPM

--------------------------------------------------------------------------

En esta pequeña demo algo más compleja crearemos una imagen con **Nginx**, **PHP 7** y **Centos**.

Iniciaremos nuestro entorno con nuestro **Dockerfile**, con el sistema operativo `Centos:7`.

```dockerfile
FROM centos:7
```

Incluimos la configuración de **nginx** para **centos**, buscando en google ([nginx repo file centos](https://www.google.com/search?client=ubuntu&hs=fzR&channel=fs&ei=vDfTW7idGZTagQaGsY3IDA&q=nginx+repo+file+centos&oq=nginx+repo+file+centos&gs_l=psy-ab.3..33i22i29i30k1l2.61802.64371.0.64586.8.8.0.0.0.0.122.734.2j5.7.0....0...1c.1.64.psy-ab..1.7.732...0i22i30k1.0.OxUdVVBP1No)), y accediendo al siguiente link: [http://nginx.org/en/linux_packages.html](http://nginx.org/en/linux_packages.html)

Y creamos el archivo del repositorio, el cual copiaremos dentro del contenedor.

_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7

++ COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
```

_[nginx.repo](nginx.repo)_
```repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/OS/OSRELEASE/$basearch/
gpgcheck=0
enabled=1
```

Es momento de incluir la instalación de **nginx**, ya que disponemos de su repositorio:

_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
++ RUN \
++  yum -y install nginx --enablerepo=nginx 
```

Más los paquetes relativos a las distintas versiones de php para nginx, instalando ius (búsqueda en google [install ius repo centos 7](https://www.google.com/search?source=hp&ei=yDnTW92aKcWYlwTxja_ABg&q=install+ius+repo+centos+7&oq=install+ius+repo+centos+7&gs_l=psy-ab.3..0.8395.8395.0.8764.3.2.0.0.0.0.112.112.0j1.2.0....0...1c.1.64.psy-ab..1.2.247.6..35i39k1.136.foPHB-bI6mk)) dentro de [https://ius.io/GettingStarted/](https://ius.io/GettingStarted/).

_[/conf/nginx.repo](./conf/nginx.repo)_
```repo
[nginx]
name=nginx repo
baseurl=http://nginx.org/packages/centos/7/$basearch/
gpgcheck=0
enabled=1
```

_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
RUN \
   yum -y install nginx --enablerepo=nginx 
++ yum -y install https://centos7.iuscommunity.org/ius-release.rpm
```

Ahora instalamos los paquetes de **php 7** en **ius** **centos** version **7**.

_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
RUN \
  yum -y install nginx --enablerepo=nginx && \
-- yum -y install https://centos7.iuscommunity.org/ius-release.rpm  
++ yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
++ yum -y install \
++   php71u-fpm \
++   php71u-cli \
++   php71u-mysqlnd \
++   php71u-soap \
++   php71u-xml \
++   php71u-zip \
++   php71u-json \
++   php71u-mcrypt \
++   php71u-mbstring \
++   php71u-zip \
++   php71u-gd                                                                
```

Y habilitamos el repo descargado:

_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
RUN \
  yum -y install nginx --enablerepo=nginx && \
  yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
  yum -y install \
    php71u-fpm \
    php71u-cli \
    php71u-mysqlnd \
    php71u-soap \
    php71u-xml \
    php71u-zip \
    php71u-json \
    php71u-mcrypt \
    php71u-mbstring \
    php71u-zip \
--  php71u-gd                                                               
++  php71u-gd \
++   --enablerepo=ius && yum clean all
```

Crearemos un par de volúmenes para alojar nuestro código:

_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
RUN \
  yum -y install nginx --enablerepo=nginx && \
  yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
  yum -y install \
    php71u-fpm \
    // ...                                                               
    php71u-gd \
     --enablerepo=ius && yum clean all

++ VOLUME /var/www/html /var/log/nginx /var/log/php-fpm /var/lib/php-fpm     
```

E incluimos la configuración dentro del contenedor mediante COPY.

_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
RUN \
  yum -y install nginx --enablerepo=nginx && \
  yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
  yum -y install \
    php71u-fpm \
    // ...                                                               
    php71u-gd \
     --enablerepo=ius && yum clean all
VOLUME /var/www/html /var/log/nginx /var/log/php-fpm /var/lib/php-fpm 

++ COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf   
```

Nuestro [/conf/nginx.conf](./conf/nginx.conf) será algo así (google [nginx php-fpm vhost example](https://www.google.es/search?ei=1krTW4uhNImRgAb7q72oAg&q=nginx+php-fpm+vhost+example&oq=nginx+php-fpm+vhost+example&gs_l=psy-ab.3..0i203k1j0i22i30k1.5355.6443.0.7223.8.8.0.0.0.0.126.868.2j6.8.0....0...1c.1.64.psy-ab..0.8.866....0.M8kmdYto6Eo)) [https://gist.github.com/lukearmstrong/7155390](https://gist.github.com/lukearmstrong/7155390):

_[/conf/nginx.conf](./conf/nginx.conf)_
```conf
server {
  listen       80;
  server_name  localhost;
  root         /var/www/html;
  index        index.php;
  access_log   /var/log/nginx/nginx-access.log;
  error_log    /var/log/nginx/nginx-error.log;

   gzip on;
   gzip_static on;
   gzip_disable "msie6";
   gzip_http_version 1.1;
   gzip_vary on;
   gzip_comp_level 6;
   gzip_proxied any;
   gzip_buffers 16 8k;
   gzip_types 
     text/plain 
     text/css
     text/x-js
     text/javascript
     application/json 
     application/x-javascript
     application/javascript;


  location = /favicon.ico {
    log_not_found off;
    access_log off;
  }

  location = /robots.txt {
    allow all;
    log_not_found off;
    access_log off;
  }

  location / {

    try_files $uri $uri/ /index.php?$args;

  }

  location ~ \.php$ {

    try_files $uri =404;
    include /etc/nginx/fastcgi_params;
    fastcgi_pass 127.0.0.1:9000;
    fastcgi_index index.php;
    fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
    fastcgi_param PATH_INFO $fastcgi_script_name;
    fastcgi_intercept_errors on;

  }
}
```

Además incluimos un script con varios CMD.

_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
RUN \
  yum -y install nginx --enablerepo=nginx && \
  yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
  yum -y install \
    php71u-fpm \
    // ...                                                               
    php71u-gd \
     --enablerepo=ius && yum clean all
VOLUME /var/www/html /var/log/nginx /var/log/php-fpm /var/lib/php-fpm 
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf 

++ COPY ./bin/start.sh /start.sh
```

_[/bin/start.sh](./bin/start.sh)_
```sh
#!/bin/bash
# Starts php process in background
/usr/sbin/php-fpm -c /etc/php/fpm
# Starts nginx daemon
nginx -g 'daemon off;'
```

E incluimos permisos de ejecución al script ya copiado:

_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
RUN \
  yum -y install nginx --enablerepo=nginx && \
  yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
  yum -y install \
    php71u-fpm \
    // ...                                                               
    php71u-gd \
     --enablerepo=ius && yum clean all
VOLUME /var/www/html /var/log/nginx /var/log/php-fpm /var/lib/php-fpm 
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf 
COPY ./bin/start.sh /start.sh

++ RUN chmod +x /start.sh
```

Para finalmente iniciar nuestro CMD.


_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
RUN \
  yum -y install nginx --enablerepo=nginx && \
  yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
  yum -y install \
    php71u-fpm \
    // ...                                                               
    php71u-gd \
     --enablerepo=ius && yum clean all
VOLUME /var/www/html /var/log/nginx /var/log/php-fpm /var/lib/php-fpm 
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf 
COPY ./bin/start.sh /start.sh
RUN chmod +x /start.sh

++ CMD /start.sh
```

Incluiremos un index.php con `<?php phpinfo(); ?>` para testear el correcto funcionamiento de nuestro contenedor:


_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
RUN \
  yum -y install nginx --enablerepo=nginx && \
  yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
  yum -y install \
    php71u-fpm \
    // ...                                                               
    php71u-gd \
     --enablerepo=ius && yum clean all
VOLUME /var/www/html /var/log/nginx /var/log/php-fpm /var/lib/php-fpm 
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf 
COPY ./bin/start.sh /start.sh

++ COPY index.php /var/www/html/index.php

RUN chmod +x /start.sh
CMD /start.sh
```

No debemos olvidar incluir los puertos expuestos: 

_[Dockerfile](./Dockerfile)_
```diff
FROM centos:7
COPY ./conf/nginx.repo /etc/yum.repos.d/nginx.repo
RUN \
  yum -y install nginx --enablerepo=nginx && \
  yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
  yum -y install \
    php71u-fpm \
    // ...                                                               
    php71u-gd \
     --enablerepo=ius && yum clean all

++ EXPOSE 80 443

VOLUME /var/www/html /var/log/nginx /var/log/php-fpm /var/lib/php-fpm 
COPY ./conf/nginx.conf /etc/nginx/conf.d/default.conf 
COPY ./bin/start.sh /start.sh
COPY index.php /var/www/html/index.php
RUN chmod +x /start.sh
CMD /start.sh
```

Ejecutaremos el comando para construir nuestra nueva imagen `docker build --tag nginx-php-fpm:v1 .`, y el comando `docker run -d --name nginx-php-fpm -p 80:80 nginx-php-fpm:v1` para montarla.

> GO TO: [http://localhost/](http://localhost/)


--------------------------------------------------------------------------

### MultiStage Building

--------------------------------------------------------------------------

#### Multi Stage Build 

El **Multi Stage Build** permite usar en un mismo **Dokerfile** usar varios FROM para crear imágenes diferentes por temas de dependencias entre las mismas.

##### Ejemplo 1

Por ejemplo, quiero crear un **jar** desde una imagen **maven** para copiar esa **jar** en una imagen **java**.

> El último FROM será siempre el válido.

Primero crearemos una imagen simple con **maven** que incluya una aplicación simple de java con maven (Google [maven sample app](https://www.google.es/search?q=maven+sample+app&oq=maven+sample+app&aqs=chrome..69i57j0l5.751j0j9&sourceid=chrome&ie=UTF-8)), cuya fuente será : [https://github.com/jenkins-docs/simple-java-maven-app](https://github.com/jenkins-docs/simple-java-maven-app).

_[Dockerfile](./Dockerfile)_
```dockerfile
FROM maven:3.5-alpine
```

Clonaremos el repositorio en nuestra carpeta de la demo, con nombre app (`git clone https://github.com/jenkins-docs/simple-java-maven-app.git`).

```bash
demo@VirtualBox:~/Demo_Docker$ git clone https://github.com/jenkins-docs/simple-java-maven-app.git
```

E incluiremos el repositorio en nuestra imagen más la línea de construcción de **maiven**:

_[Dockerfile](./Dockerfile)_
```diff
FROM maven:3.5-alpine
++ COPY app /app
++ RUN cd /app && mvn package
```

Construimos la imagen como primera versión: `docker build -t java-multi-stage-build:v1 .`

Ejecutamos `docker images` para ver y comparar el tamaño de las imágenes resultantes, la generada más la inicial de maiven. 

```bash
demo@VirtualBox:~/Demo_Docker$ docker images
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
java-multi-stage-build   v1                  28e4136653f4        28 seconds ago      131MB
```

> Gracias al **Multi-stage-build** evitaremos añadir a la imagen a suma de capas que la haría más pesada, reduciendo su tamaño y refactorizandola ya que incluirá sólo las capas necesarias más los archivos generados resultantes.

Ahora incluiremos el nuevo FROM en nuestro **Dockerfile** para incluir desde dónde queremos copiar nuestro **jar**

_[Dockerfile](./Dockerfile)_
```diff
-- FROM maven:3.5-alpine
++ FROM maven:3.5-alpine as builder
COPY app /app
RUN cd /app && mvn package

++ FROM openjdk:8-alpine
++ COPY --from=builder /app/target/my-app-1.0-SNAPSHOT.jar /opt/app.jar
++ CMD java -jar /opt/app.jar
```

Si volvemos a generar la imagen esta vez como **v2**, `docker build -t java-multi-stage-build:v2 .`, y ejecutamos `docker images` veremos que la actual imagen pesa menos que la versión 1. Esta imagen resultante se generará a partir del segundo FROM más el resultante de la generación de la primera parte del Dockerfile, obviando lo innecesario.

```bash
demo@VirtualBox:~/Demo_Docker$ docker images
REPOSITORY               TAG                 IMAGE ID            CREATED             SIZE
java-multi-stage-build   v2                  1cbc38958306        3 seconds ago       103MB
java-multi-stage-build   v1                  28e4136653f4        4 minutes ago       131MB
```

Finalmente ejecutaremos el comando `docker run -d --name java-multi-stage-build-v2 java-multi-stage-build:v2` para lanzar el contenedor y `docker ps -a` para ver el resultado (ya que el contenedor habrá muerto tras imprimir **hello-world**.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name java-multi-stage-build-v2 java-multi-stage-build:v2
1752b43105cbdbdae11dfce128d1623d4a0eeec51c91b9e092e1b832764e96d4

demo@VirtualBox:~/Demo_Docker$ docker ps -a
CONTAINER ID  IMAGE                       COMMAND                  CREATED        STATUS       PORTS       NAMES
1752b43105cb  java-multi-stage-build:v2   "/bin/sh -c 'java -j…"   6 seconds ago  Exited (0) 5 secondsago java-multi-stage-build-v2

demo@VirtualBox:~/Demo_Docker$ docker logs java-multi-stage-build-v2
hello-world
```

##### Ejemplo 2

Construyamos nuestra imagen a partir del siguiente **Dockerfile**.

_[Dockerfile](./Dockerfile)_
```dockerfile
FROM centos

RUN fallocate -t 10M /opt/file1
RUN fallocate -t 20M /opt/file2
RUN fallocate -t 30M /opt/file3
```

> Nota: El comando de linux `fallocate -t <sizefile> <file-location>`(ejemplo `fallocate -t 10M /opt/file1`) permite generar archivos de un peso determinado.

Al generar esta imagen con el comando `docker build --tag muilti-stage-fallocate:v1 .` veremos que se genera una imagen de un peso .

Si repetimos la estrategia anterior, imaginando que la resultante de la compilación de esos tres archivos es uno nuevo de pero 20M, observaremos que la imagen resultante pasa a pesar x.

_[Dockerfile](./Dockerfile)_
```diff
-- FROM centos
++ FROM centos as test

-- RUN fallocate -t 10M /opt/file1
-- RUN fallocate -t 20M /opt/file2
-- RUN fallocate -t 30M /opt/file3
++ RUN fallocate -t 20M /opt/result

++ FROM alpine
++ COPY --from=test /opt/test2 /opt/myfile
```