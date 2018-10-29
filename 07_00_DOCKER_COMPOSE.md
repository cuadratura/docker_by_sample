--------------------------------------------------------------------------

### Docker Compose

--------------------------------------------------------------------------

**Docker Compose** es una herramienta de **docker** que permite crear aplicaciones multicontenedor, un ejemplo sería un sitio con wordpress que necesita de un contenedor Apache más un contenedor Mysql.

Docker compose permitiría definir toda la configuración necesaria para conectar los contenedores, imágenes, volúmenes y redes dentro de un único archivo.

--------------------------------------------------------------------------

### Instalación Docker Compose

--------------------------------------------------------------------------

Fuente: [https://docs.docker.com/compose/install/#install-compose](https://docs.docker.com/compose/install/#install-compose)

Para instalarlo ejecutaremos el comando `sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`.

> Nota: se recomienda previamnete pasarse al usuario **root** `sudo su`.

```bash
demo@VirtualBox:~/Demo_Docker$ sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
[sudo] password for hector:
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100   617    0   617    0     0    922      0 --:--:-- --:--:-- --:--:--   920
100 11.2M  100 11.2M    0     0  2821k      0  0:00:04  0:00:04 --:--:-- 4291k
```

Para posteriormente otorgarle permisos de ejecución mediante `sudo chmod +x /usr/local/bin/docker-compose`.

```bash
demo@VirtualBox:~/Demo_Docker$ sudo chmod +x /usr/local/bin/docker-compose
```

Y ejecutar la línea `/usr/local/bin/docker-compose`, para ver todas las opciones activas de **docker compose**.

```bash
demo@VirtualBox:~/Demo_Docker$ /usr/local/bin/docker-compose
Define and run multi-container applications with Docker.
// ...
```

--------------------------------------------------------------------------

### Primeros Pasos Con Docker Compose

--------------------------------------------------------------------------

Creamos una carpeta llamada **docker-compose** usando el comando `mkdir docker-compose` y accedemos a él `cd docker-compose`.

El se ejecutará sobre un archivo de configuración de nominado [docker-compose.yml](./docker-compose.yml), este dispondrá de 4 apartados:
    * `version:` - Obligatorio - 
    * `services:` - Obligatorio - 
    * `volumes:` - NO Obligatorio - 
    * `network:` - NO Obligatorio - 

**¿Cuál es la diferencia entre crear un contenedor con Docker Compose y sin él?**  

Pasaríamos de usar un comando `docker run -d -p 8080:80 --name nginx-v1 nginx` cada vez que queramos crear un contenedor a crear un archivo [docker-compose.yml](./docker-compose.yml) con la configuración y usar `docker-compose up -d` para levantarlo. 

_[docker-compose.yml](./docker-compose.yml)_
```yml
# Se recomienda usar siempre la última version de docker compose
version: '3'
# 
services:
    # Nuestro primer servicio se llamará `web`
    web:
        # https://docs.docker.com/compose/compose-file/
        container_name: nginx-v1
        ports:
            - "8080:80"
        image: nginx
```     

Ejecutamos el comando `docker-compose up -d` para levantar el conetendor.

```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose up -d
Creating network "docker-compose_default" with the default driver
Creating nginx-v1 ... done
```

Ahora podemos acceder en nuestro navegador a [http://localhost:8080/](http://localhost:8080/) para ver nuestro contenedor levantado.

Y `docker-compose down` para pararlo.

```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose down
Stopping nginx-v1 ... done
Removing nginx-v1 ... done
Removing network docker-compose_default
```

> Ejecutaremos `docker-compose down` para detener nuestro contenedor.

--------------------------------------------------------------------------

### Ejecutar la configuración de Docker Compose en un archivo alternativo

--------------------------------------------------------------------------

Para ejecutar la configuración de **Docker Compose** en un archivo alternativo utilizaremos el comando `docker-compose -f <filename-docker-compose> up -d`, como por ejemplo `docker-compose -f docker-compose-cmd.yml up -d`.


--------------------------------------------------------------------------

### Variables de entorno

--------------------------------------------------------------------------

Creamos un nuevo contenedor con **Docker Compose**.

_[docker-compose.yml](./docker-compose.yml)_
```yml
# Se recomienda usar siempre la última version de docker compose
version: '3'
# 
services:
    # Nuestro primer servicio se llamará `db`
    db:
        # https://docs.docker.com/compose/compose-file/
        container_name: mysql
        ports:
            - "3306:3306"
        image: mysql:5.7
        environment:
            - "MYSQL_ROOT_PASSWORD=12345678"
```

Y lanzamos el contenedor `docker-compose up -d`.

Ahora accedemos dentro del contenedor `docker exec -ti mysql bash`, para ver las variables de entorno existente `env`, y comporbar que la incluimos está dentro.

```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose up -d
WARNING: Found orphan containers (nginx-v1) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
Creating mysql ... done

demo@VirtualBox:~/Demo_Docker$ docker exec -ti mysql bash

root@b51e42610b98:/# env
// ...
MYSQL_ROOT_PASSWORD=12345678
// ...
root@b51e42610b98:/#
```

Y nos logueamos dentro del contenedor en la base de datos `mysql -u root -p12345678`

```bash
root@b51e42610b98:/# mysql -u root -p12345678
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
// ...
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> exit
Bye
```
> Ejecutaremos `docker-compose down` para detener nuestro contenedor.

--------------------------------------------------------------------------

### Variables de entorno - Alternativa

--------------------------------------------------------------------------

Una alternativa es separar las variables en un archivo distinto denominado [common.env](./common.env).

Creamos un nuevo contenedor con **Docker Compose**, que referencie las variables de entorno en un archivo externo [common.env](./common.env).

_[docker-compose.yml](./docker-compose.yml)_
```yml
version: '3'
services:
    db:
        container_name: mysql-v2
        ports:
            - "3306:3306"
        image: mysql:5.7
        env_file: common.env
```

_[common.env](./common.env)_
```yml
version: '3'
services:
    db:
        container_name: mysql-v2
        ports:
            - "3306:3306"
        image: mysql:5.7
        env_file: common.env
```

Y lanzamos el contenedor `docker-compose up -d`.

Ahora podríamos ejecutar las mismas comprobaciones anteriores.

> Ejecutaremos `docker-compose down` para detener nuestro contenedor.

--------------------------------------------------------------------------

### Volúmenes | Nombrados

--------------------------------------------------------------------------

Creamos nuestra configuración **Docker Compose**.

_[docker-compose.yml](./docker-compose.yml)_
```yml
version: '3'
services:
    web:
        container_name: nginx-2
        ports:
            - "8080:80"
        image: nginx
        volumes:
            - "vol2:/user/share/nginx/html"
volumes:
    vol2:
```

Y ejecutamos `docker-compose up -d` para lanzar el servicio.

```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose up -d
Creating network "docker-compose_default" with the default driver
Creating volume "docker-compose_vol2" with default driver
Creating nginx-2 ... done
```

Vemos que se generó una red denominada **docker-compose_default** y un volumen **docker-compose_vol2**.

Para comprobar que efectivamente funciona el volumen, accederemos al **document Root de Docker** mediante el comando `docker info | grep -i root`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker info | grep -i root
WARNING: No swap limit support
Docker Root Dir: /var/lib/docker
```

Cambiamos nuestro rol `sudo su` y accedemos a la ubicación `/var/lib/docker/volumes/docker-compose_vol2/_data` para modificar nuestro `index.html`.

```bash
demo@VirtualBox:~/Demo_Docker$ sudo su
[sudo] password for hector:
root@VirtualBox:~/Demo_Docker$ 
```

Desmontamos nuestro contenedor `docker-compose down` y lo volvemos a generar `docker-compose up -d` para acceder de nuevas a [http://localhost:8080/](http://localhost:8080/) para ver nuestro contenedor levantado. 

> Ejecutaremos `docker-compose down` para detener nuestro contenedor.

--------------------------------------------------------------------------

### Volúmenes | Host (FAILED) (80)

--------------------------------------------------------------------------

Creamos nuestra configuración **Docker Compose**.

Creamos la carpeta que alojará el volumen `mkdir html` y le otorgamos permisos de ejecución `sudo chown 1000 -R ~/docker-compose/html`, siendo **/home/demo/docker-compose/** nuestra carpeta.

_[docker-compose.yml](./docker-compose.yml)_
```yml
version: '3'
services:
    web:
        container_name: nginx-2
        ports:
            - "8080:80"
        image: nginx
        volumes:
            - "/home/demo/docker-compose/html:/user/share/nginx/html"
```

Y ejecutamos `docker-compose up -d` para lanzar el servicio.

```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose up -d
Creating network "docker-compose_default" with the default driver
Creating volume "docker-compose_vol2" with default driver
Creating nginx-2 ... done
```

Vemos que se generó una red denominada **docker-compose_default** y un volumen **docker-compose_vol2**.

Para comprobar que efectivamente funciona el volumen, accederemos al **document Root de Docker** mediante el comando `docker info | grep -i root`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker info | grep -i root
WARNING: No swap limit support
Docker Root Dir: /var/lib/docker
```

Cambiamos nuestro rol `sudo su` y accedemos a la ubicación `/var/lib/docker/volumes/docker-compose_vol2/_data` para modificar nuestro `index.html`.

```bash
demo@VirtualBox:~/Demo_Docker$ sudo su
[sudo] password for hector:
root@VirtualBox:~/Demo_Docker$ 
```

Desmontamos nuestro contenedor `docker-compose down` y lo volvemos a generar `docker-compose up -d` para acceder de nuevas a [http://localhost:8080/](http://localhost:8080/) para ver nuestro contenedor levantado. 

> Ejecutaremos `docker-compose down` para detener nuestro contenedor.

--------------------------------------------------------------------------

### Network (FAILED) (81-82)

--------------------------------------------------------------------------

Para incluir una red en nuestro contenedor simplemente seguiremos un ejemplo como este **Docker Compose**.

_[docker-compose.yml](./docker-compose.yml)_
```yml
version: '3'
services:
    web-1:
        container_name: Apache
        ports:
            - "8081:80"
        image: httpd
        networks:
            - net-test           
networks:
    net-test:
```

Creamos una red con ese nombre para que disponga de una configuracion `docker network create net-test`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network create net-test
a22f7dd07b48cfb0b042fc1562966ccbc9c062c6cc442a2170546f3aa9216267
```
Y levantamos el servicio `docker-compose up -d`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose up -d
Creating network "docker-compose_net-test" with the default driver
Creating Apache ... done
```

Podemos inspeccionar nuestro servicio, `docker inspect Apache` y ver que tendríamos una red creada llamada `docker network`.

```bash
$ docker inspect Apache
[
    {
        "Id": "9c6749abd506762307f4e8f947de7605c4efc1ae0c32e27121c765d77f59d0da",
// ...
            "Networks": {
                "docker-compose_net-test": {
// ...
                    "Gateway": "192.168.96.1",
                    "IPAddress": "192.168.96.2",
// ...
                }
            }
        }
    }
]
```

Si incluyesemos un segundo contenedor en nuestro servicio.

_[docker-compose.yml](./docker-compose.yml)_
```diff
version: '3'
services:
    web-1:
        container_name: Apache
        ports:
            - "8081:80"
        image: httpd
        networks:
            - net-test   
++   web-2:
++       container_name: Apache-2
++       ports:
++           - "8082:80"
++       image: httpd
++       networks:
++           - net-test                      
networks:
    net-test:
```

Y ejecutamos `docker-compose up -d` para lanzar el servicio.

```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose up -d
Creating network "docker-compose_net-test" with the default driver
Creating Apache-2 ... done
Creating Apache ... done
```

Podríamos acceder a la terminal del primero para tester mediante un **PING** la comunicación entre ambos usando `docker exec Apache bash -c "ping Apache-2"`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec Apache bash -c "ping Apache-2"
PING 172.124.10.4 (172.124.10.4) 56(84) bytes of data.
64 bytes from 172.124.10.4: icmp_seq=1 ttl=64 time=0.085 ms
64 bytes from 172.124.10.4: icmp_seq=2 ttl=64 time=0.066 ms
```

> Ejecutaremos `docker-compose down` para detener nuestro contenedor.

--------------------------------------------------------------------------

### Imágenes

--------------------------------------------------------------------------

Podemos crear imágenes mediante **Docker Compose** usando el comando `docker-compose build`.

Nuestro [docker-compose.yml](./docker-compose.yml) será así:

_[docker-compose.yml](./docker-compose.yml)_
```yml
version: '3'
services:
    web-1:
        container_name: web-1
        # Imagen personal
        image: web-test
        build: .
```

Y dispondremos de un [Dockerfile](./Dockerfile) así:

_[Dockerfile](./Dockerfile)_
```dockerfile
FROM centos
RUN mkdir /opt/test
```

Este sistema construirá una imagen desde un [Dockerfile](./Dockerfile) que se encuentre en la misma carpeta.

**¿Cómo se haría si [Dockerfile](./Dockerfile) se llamara de otra forma?**

_[docker-compose.yml](./docker-compose.yml)_
```yml
version: '3'
services:
    web-2:
        container_name: web-2
        # Imagen personal
        image: web-test
        build: 
            context: .
            dockerfile: Dockerfile1
```

Y dispondremos de un [Dockerfile](./Dockerfile) así:

_[Dockerfile1](./Dockerfile1)_
```dockerfile
FROM centos
RUN mkdir /opt/test
```

Igualmente construiríamos la imagen mediante el comando `docker-compose build`.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Modificar un CMD de un contenedor (FAILED) (83)

--------------------------------------------------------------------------

Primeramente vamos a crear un contenedor con centos `docker run -dti --name centos centos`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -dti --name centos centos
de5db3af8f2cfb689d4a02adc87c7c6874245699155091a04b26d5d6d431dced4
```

Y vemos con `docker ps` que **CMD** usa centos por defecto (`/bin/bash`).

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE   COMMAND     CREATED  STATUS   PORTS  NAMES
e5db3af8f2cf centos  "/bin/bash" 2 sec... Up 1 ..         centos
```

Para sustituirlo crearemos el siguiente [docker-compose.yml](docker-compose.yml).

_[docker-compose.yml](./docker-compose.yml)_
```bash
version: '3'
services:
    web:
        image: centos
        command: phyton -m SimpleHTTPServer 8080
        ports: 
            - "8080:8080"
```

Ejecutaremos `docker-compose up -d`.


```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose up -d
Creating network "docker-compose_web_1" with the default driver
// ...
```

Y si ejecutamos `docker ps` veremos que el cmd se ha sustituido.

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE   COMMAND      CREATED  STATUS   PORTS  NAMES
e5db3af8f2cf centos  "phyton ..." 2 sec... Up 1 ..         centos
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Limitar Recursos de un Contenedores

--------------------------------------------------------------------------

Para este ejemplo usaremos el siguiente [docker-compose.yml](./docker-compose.yml).

_[docker-compose.yml](./docker-compose.yml)_
```bash
version: '3'
services:
    web:
        container_name: nginx
        deploy:
            resources:
                limits:
                    cpus: '0'
                    memory: 20M        
        image: nginx:alpine
```

Ejecutamos `docker-compose up -d` para lanzar el servicio.

```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose up -d
Creating network "docker-compose_web_1" with the default driver
// ...
```

Y ejecutamos el comando `docker stats nginx` para ver el consumo de recursos.

```bash
demo@VirtualBox:~/Demo_Docker$ docker stats nginx
CONTAINER ID  NAME  CPU %  MEM USAGE/LIMIT    MEM %  NET I/O    BLOCK I/O  BLOCK I/O           PIDS
ea5f37088bf4  nginx 0.00%  2.066MiB/6.313GiB  0.03%  9.24kB/0B  0B/0B      0B/0B 0B/0B  
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Política de Reinicio de Contenedores en Docker

--------------------------------------------------------------------------

Esto delimita las condiciones en las que un contenedor debería ser reiniciado.

* **no** - No reinicia automáticamente el contenedor. (por defecto)
* **on-failure** - Reinicie el contenedor si sale debido a un error, que se manifiesta como un código de salida distinto de cero.
* **unless-stopped** - A menos que esté detenido Reinicie el contenedor a menos que se detenga explícitamente o que el propio Docker se detenga o reinicie.
* **always** - Reinicie siempre el contenedor si se detiene.

Generamos nuestro [docker-compose.yml](./docker-compose.yml).

_[docker-compose.yml](./docker-compose.yml)_
```bash
version: '3'
services:
    test:
        container_name: test
        image: restart-image
        build: .
```

Con el siguiente [Dockerfile](./Dockerfile):

_[Dockerfile](./Dockerfile)_
```bash
FROM centos
COPY start.sh /start.sh
RUN chmod +x /start.sh
CMD /start.sh
```

El cual ejecutará el CMD con el script [start.sh](./start.sh).

_[start.sh](start.sh)_
```bash
#!/bin/bash
echo "Estoy vivo"
sleep 5
echo "Estoy detenido"
```

Al construir la imagen con **docker compose** `docker-compose build`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose build
Building test
Step 1/4 : FROM centos
// ...
```

Y creamos nuestro servicio `docker-compose up -d`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose up -d
WARNING: Found orphan containers (nginx) for this project. If you removed or renamed this service in your compose file, you can run this command with the --remove-orphans flag to clean it up.
Creating test ... done
```

Ejecutamos seguidamente `docker ps` para ver que el contenedor está vivo, para repetir el comando a los 10 segundos `docker ps` y ver que el contenedor ya murió. Si lanzasemos el comando `docker logs -f restart image` veríamos que se ejecutó correctamente.


**ALWAYS**

Ahora incluimos la opción de **restart** como **always**. 

_[docker-compose.yml](./docker-compose.yml)_
```diff
version: '3'
services:
    test:
        container_name: test
        image: restart-image
        build: .
++       restart: always
```

Por lo que deberemos regerar la imagen con **docker compose** `docker-compose build`. Y volvemos a lanzar el servicio `docker-compose up -d`.

```bash
demo@VirtualBox:~/Demo_Docker$ watch -d docker ps

Every 2.0s: docker ps              demo-VirtualBox: Sun Oct 28 18:05:36 2018

CONTAINER ID IMAGE          COMMAND                  CREATED             STATUS            
239851457ac6 restart-image  "/bin/sh -c /start.sh"   26 seconds ago      Up 5 seconds
```

Veremos que el servicio se reinicia **SIEMPRE** de forma automática cuando muere.

**UNLESS STOPPED**

Esta opción reiniciará el contenedor a no ser que nosotros lo paremos manualmente.Ahora incluimos la opción de **restart** como **Unless Stopped**.

_[docker-compose.yml](./docker-compose.yml)_
```diff
version: '3'
services:
    test:
        container_name: test
        image: restart-image
        build: .
++       restart: unless-stopped
```

Por lo que deberemos regerar la imagen con **docker compose** `docker-compose build`. Y volvemos a lanzar el servicio `docker-compose up -d`.

```bash
demo@VirtualBox:~/Demo_Docker$ watch -d docker ps

Every 2.0s: docker ps              demo-VirtualBox: Sun Oct 28 18:05:36 2018

CONTAINER ID IMAGE          COMMAND                  CREATED             STATUS            
239851457ac6 restart-image  "/bin/sh -c /start.sh"   26 seconds ago      Up 5 seconds
```

Veremos que el servicio se reinicia **SIEMPRE** de forma automática cuando muere, a menos que lo paremos nosotros.

**ON-FAULIRE**

Esta opción reiniciará el contenedor a no ser ocurra un error con un código de error 0 (finaliza correctamente el contenedor)(1 finalizaría con error). Ahora incluimos la opción de **restart** como **On faulire**.

_[docker-compose.yml](./docker-compose.yml)_
```diff
version: '3'
services:
    test:
        container_name: test
        image: restart-image
        build: .
++       restart: on-faulire
```

Por lo que deberemos regerar la imagen con **docker compose** `docker-compose build`. Y provocamos un error intencionado en el script [start.sh](start.sh).

_[start.sh](start.sh)_
```diff
#!/bin/bash
echo "Estoy vivo"
sleep 5
echo "Estoy detenido"
++ exit 1
```

Y volvemos a lanzar el servicio `docker-compose up -d`.

```bash
demo@VirtualBox:~/Demo_Docker$ watch -d docker ps

Every 2.0s: docker ps              demo-VirtualBox: Sun Oct 28 18:05:36 2018

CONTAINER ID IMAGE          COMMAND                  CREATED             STATUS            
239851457ac6 restart-image  "/bin/sh -c /start.sh"   26 seconds ago      Up 5 seconds
```

Veremos que el servicio se reinicia **SIEMPRE** de forma automática cuando muere, a menos que lo paremos nosotros.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.


--------------------------------------------------------------------------

### Cambiar el nombre del Proyecto

--------------------------------------------------------------------------

Docker compose coge por defecto para el nombre de proycto el nombre de la carpeta dónde se aloja el mismo.

Para cambiar el nombre del servicio por defecto usaremos la siguiente línea al lanzar el servicio `docker-compose -p <name-service> up -d` o `docker-compose -p <name-service> -f <filename-docker-compose> up -d`, un ejemplo sería `docker-compose -p web-test up -d`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker-compose -p web-testup -d
Creating network "web-test_default" with the default driver
Creating test ... done
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.


--------------------------------------------------------------------------

### Usar un Nombre Personalziado en docker-compose.yml

--------------------------------------------------------------------------

Para ejecutar la configuración de **Docker Compose** en un archivo alternativo utilizaremos el comando `docker-compose -f <filename-docker-compose> up -d`, como por ejemplo `docker-compose -f docker-compose-cmd.yml up -d`.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Más Opciones Docker Compose

--------------------------------------------------------------------------

Para ver las distintas opciones existentes de **Docker Compose** simplemente deberemos escribir en consola el comando `docker-compose`.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

(Source: [https://examples.javacodegeeks.com/devops/docker/docker-tutorial-for-java-developers/](https://examples.javacodegeeks.com/devops/docker/docker-tutorial-for-java-developers/))