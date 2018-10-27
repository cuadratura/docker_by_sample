> Los volúmenes permiten almacenar data persistente del contenedor, en caso de que el contenedor se elimine. Es muy útil para contendores de bases de datos.

Existen tres tipos de volúmenes:
* **Host**, son volúmenos que se almacenan dentro de nuestro **dockerhost** y se almacenan en una carpeta de nuestro docker file que nosotros definimos previamente.
* **Anonymus**, no se definen en una carpeta, pero docker los guarda en una capreta random
* **Named Volumnes**, no son carpetas administradas por docker, peroa  diferencias de **Anonymus** disponen de un nombre.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Como Acceder a Document Root de Docker

--------------------------------------------------------------------------

Para acceder al Document Root de Docker necesitamos estar logueado como administrador `sudo su`, para posteriormente mediante el comando `docker info | grep -i root` visualizar la carpeta dónde se aloja toda la información de docker `Docker Root Dir: /var/lib/docker`.

```bash
demo@VirtualBox:~/Demo_Docker$ sudo su
[sudo] password for hector:

root@VirtualBox:~/Demo_Docker$ docker info | grep -i root
WARNING: No swap limit support
Docker Root Dir: /var/lib/docker
```

Ahora podríamos navegar por los directorios hasta acceder a ella para visualizar el contenido de nuestro **docker**

```bash
root@VirtualBox:/var/lib/docker# ls
builder  buildkit  containerd  containers  image  network  overlay2  plugins  runtimes  swarm  tmp  trust  volumes
```

--------------------------------------------------------------------------

### ¿Por qué son importantes los volúmenes?

--------------------------------------------------------------------------

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

Creamos nuestra imagen inicial `docker run -d -p 3306:3306 --name my-db -e "MYSQL_ROOT_PASSWORD=12345678" -e "MYSQL_DATABASE=docker-db" -e "MYSQL_USER=docker-user" -e "MYSQL_PASSWORD=87654321" mysql:5.7`.

```bash
root@VirtualBox:~/Demo_Docker$ docker run -d -p 3306:3306 --name my-db -e "MYSQL_ROOT_PASSWORD=12345678" -e "MYSQL_DATABASE=docker-db" -e "MYSQL_USER=docker-user" -e "MYSQL_PASSWORD=87654321" mysql:5.7
7b643bf5ba29f162b60365bea8217cb51072fdb1f8fb29f721096054ae75fc29

root@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE     COMMAND CREATED STATUS  PORTS  NAMES
7b643bf5ba29 mysql:5.7 "dock…" 9 se..  Up ..   0.0..  my-db
```
Podremos ver cuando finalizó la carga del contenedor a través del logs `docker logs -f my-db`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker logs -f my-db
Initializing database
2018-10-27T16:45:14.283612Z 0 [Warning] TIMESTAMP with implicit 
// ...
2018-10-27T16:45:28.911040Z 0 [Note] mysqld: ready for connections.
Version: '5.7.24'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)

demo@VirtualBox:~/Demo_Docker$ 
```

Accedemos a mysql `mysql -u root -h 127.0.0.1 -p` e introduciremos el password del root indicado al montar el contenedor `12345678`.

```bash
demo@VirtualBox:~/Demo_Docker$ mysql -u root -h 127.0.0.1 -p
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
// ... 
```

Mostramos las tablas existentes `show databases;`, usamos la base de datos **docker-db** `use docker-db` y mostramos sus tablas `show tables;`

```bash
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| docker-db          |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.01 sec)

mysql> use docker-db
Database changed
mysql> show tables;
Empty set (0.00 sec)

mysql> exit
Bye
```

Ahora hacemos un **dump** para descargar la base de datos existente `mysqldump -u root -h 127.0.0.1 -p12345678 information_schema > dump.sql`

```bash
$ mysqldump -u root -h 127.0.0.1 -p12345678 information_schema > dump.sql
mysqldump: [Warning] Using a password on the command line interface can be insecure.
mysqldump: Got error: 1044: Access denied for user 'root'@'%' to database 'information_schema' when using LOCK TABLES
```

E importamos esa base de datos descargados a **docker-db** `mysql -u root -h 127.0.0.1 -p docker-db < dump.sql` (nos pedirá introducir el password del usuario **root**)

```bash
demo@VirtualBox:~/Demo_Docker$ mysql -u root -h 127.0.0.1 -p docker-db < dump.sql
Enter password:
```

Volvemos a conectar con **docker-db** para ver su contenido, `mysql -u root -h 127.0.0.1 -p docker-db`

```bash
demo@VirtualBox:~/Demo_Docker$ mysql -u root -h 127.0.0.1 -p docker-db
Enter password:
Welcome to the MySQL monitor.  Commands end with ; or \g.
// ... 
```

Mostramos las tablas existentes `show databases;`, usamos la base de datos **docker-db** `use docker-db` y mostramos sus tablas `show tables;`

```bash
Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| docker-db          |
| mysql              |
| performance_schema |
| sys                |
+--------------------+
5 rows in set (0.01 sec)

mysql> use docker-db
Database changed
mysql> show tables;
Empty set (0.00 sec)

mysql> exit
Bye
```

Ahora deberíamos ver que se ha copiado el contendio dentro de la base de datos **docker-db**. 

Si borramos el contenedor, esta información desaparecería, para evitarlo usaremos los volúmenes.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.


--------------------------------------------------------------------------

### Caso MySQL

--------------------------------------------------------------------------

Para poder guardar la información relativa a las Bases de Datos de MySQL lo primero que necesitamos saber es dónde guarda esa información para incluirla dentro de los volúmenes. Para ello, lo buscaremos en Google.

Crearemos una carpeta dónde se encuentre el proyecto llamada **mysql** con permisos de escritura (`mkdir mysql` o `sudo mkdir mysql`)

`docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=12345678" -v /opt/mysql/:/var/lib/mysql mysql:5.7`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=12345678" -v /opt/mysql/:/var/lib/mysql mysql:5.7
74a5ea6a9644d5589e2a37726fd2b07e3baa094f4792c6835490d31075892a53

demo@VirtualBox:~/Demo_Docker$ docker logs -f db
Initializing database
2018-10-27T17:50:16.517664Z 0 [Warning] TIMESTAMP with 
// ...
2018-10-27T17:50:29.578813Z 0 [Note] mysqld: ready for connections.
Version: '5.7.24'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
```

Ingresamos en nuestro contenedor `mysql -u root -h 127.0.0.1 -p12345678`

```bash
demo@VirtualBox:~/Demo_Docker$ mysql -u root -h 127.0.0.1 -p12345678
mysql: [Warning] Using a password on the command line interface can be insecure.
// ...

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> 
```

Creamos una base de datos **test1**, `create database test1;` y comprobamos si existe `show databases;`.

```bash
mysql> create database test1;
Query OK, 1 row affected (0.00 sec)

mysql> show databases;
+--------------------+
| Database           |
+--------------------+
| information_schema |
| mysql              |
| performance_schema |
| sys                |
| test1              |
+--------------------+
5 rows in set (0.00 sec)

mysql> exit
exit
```

Si ahora elimino el contenedor `docker rm -fv db`, la vuelvo a crear `docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=12345678" -v /opt/mysql/:/var/lib/mysql mysql:5.7`, entro en el contenedor `mysql -u root -h 127.0.0.1 -p12345678` y comprueblo el listado de bases de datos, `show databases` veré que **test1** se mantiene.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.


--------------------------------------------------------------------------

### Volúmenes Anónimos

--------------------------------------------------------------------------

Ahora al definir el **volumen** obviaremos la carpeta de destino, `docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=12345678" -v /var/lib/mysql mysql:5.7` indicando sólo la carpeta que queremos copiar.

Esta se alojará dentro de nuestro **Document root** de Docker en la carpeta volúmenes en una carpeta random.

Si ejecutasemos nada más montar la imagen un `docker inspect mysql | grep <cointainer-id>`, `docker inspect mysql | grep a024e29e945b5817dd5` veríamos la ubicación del mismo.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=12345678" -v /var/lib/mysql mysql:5.7
a024e29e945b5817dd58c543a5b8495f4edd8395706d4d51d186fac5f21916b0
demo@VirtualBox:~/Demo_Docker$ docker inspect mysql | grep a024e29e945b5817dd5
```

> Estos volúmenes no se recomiendan ya que usan carpetas de almacenaje deficiles de gestioanr por su nombren, y ya que si eliminaos el contenedor con este comando `docker -rm -fv mysql` también se elimina el volumen, hecho que evitaremos si usamos `docker -rm -f mysql`.

Para retomar el contenedor que ya no corre deberemos incluir la ubicación random del volumen en su comando de generación tal que así: `docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=12345678" -v /var/lib/docker/a024e29e945b5817dd58c543a5b8495f4edd8395706d4d51d186fac5f21916b0:/var/lib/mysql mysql:5.7`, siendo `/var/lib/docker/a024e29e945b5817dd58c543a5b8495f4edd8395706d4d51d186fac5f21916b0`la ubicación del volumen anónimo de nuestro contenedor.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Volúmenes Nombrados

--------------------------------------------------------------------------

**¿Cómo creamos un volumen Nombrad?** Para ello usaremos el comando `docker volume create <volumen-name>`, en este caso usaremos `docker volume create mysql-data`.

Vamos a comprobar que efectivamente se generó ese volumen, para ello volvemos a capturar el **Root de Docker**, `docker info | grep -i root` y accedemos a él como administrador `sudo su`.

```bash
demo@VirtualBox:~/Demo_Docker$ sudo su
[sudo] password for hector:

root@VirtualBox:~/Demo_Docker$ docker info | grep -i root
WARNING: No swap limit support
Docker Root Dir: /var/lib/docker
```

Ahora podríamos navegar por los directorios hasta acceder a ella para visualizar el contenido de nuestro **docker**

```bash
root@VirtualBox:/var/lib/docker# ls
builder  buildkit  containerd  containers  image  network  overlay2  plugins  runtimes  swarm  tmp  trust  volumes
```

Posteriormente entramos en volúmenes `cd volumes` y listamos las carpetas existentes `ls`.

```bash
root@VirtualBox:/var/lib/docker# cd volumes

root@hector-VirtualBox:/var/lib/docker/volumes# ls
mysql-data
```

> Otra opción es usar el comando `docker volume ls` para listarlos directamente.

```bash
demo@VirtualBox:~/Demo_Docker$ docker volume ls
DRIVER              VOLUME NAME
local               mysql-data
```

> Para eliminarlo usaremos `docker volume rm mysql-data`.

Una vez creado el volumen, `docker volume create mysql-data` podremos asociarlo a un contenedor tal que así `docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=12345678" -v mysql-data:/var/lib/mysql mysql:5.7`, siendo `mysql-data` el volumen creado anteriormente.


> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Dangling volumes

--------------------------------------------------------------------------

Al igual que con las imágenes pueden quedarse los volúmenes huefanos, esto ocurre cuando creamos un contenedor que usa un volumen anónimo, por ejemplo `docker run -d --name db -p 3306:3306 -e "MYSQL_ROOT_PASSWORD=12345678" -v /var/lib/mysql mysql:5.7`. Y posteriormente los eliminamos sin la opción `v`, `docker rm -f db`, así se eliminará el contenedor pero el volumen no quedándo el mismo huerfano y ocupando espacio en nuestra máquina. 

Esto puede dar lugar a un problema de consumo de recursos, **¿Cómo podemos eliminarlos?**. Para ello usaríamos `docker volume ls` para listarlos, y usar `docker volume ls -f dangling=true` para mostrar los **volúmenes Dangling** (sin referenciar con contenedores).

Finalmente usaremos `docker volume ls -f dangling=true -q` para obtener sólo los **id** y `docker volume ls -f dangling=true -q | xargs docker volume rm` para eliminarlos.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Persisitiendo Data con Mongo

--------------------------------------------------------------------------

Usaremos el comando de descarga del repositorio de **Mongo** `docker pull mongo`.

Para correr la imagen de mongo descargada usaremos el comando siguiente `docker run -d --name <container-name> -p <machine-port>:<container-port> -v <location-volumen-machine>:<location-volumen-container> <image-name>:<image-tag>`, `docker run -d --name mongo-data -p 27017:27017 -v /opt/mongo/:/data/db mongo`.

Si buscamos en la documentación oficial de mongo veremos que guarda su contenido creado dentro de `/data/db`.

> Nota: Previamente será necesario crear la carpeta `/opt/mongo/`que será dónde se guaradrá nuestro volumen.

Podremos crear una base de datos con mongo dentro del contenedor para ver si verdaderamente se mantiene el contendio creado. Accedemos al contenedor `docker exec -ti mongo-data bash` y escribimos `mongo` dentro del contenedor para montar mongo. Y escribimos ne la terminal `use mydb` para seleccionar la tabla **mydb**, `db.movie.insert({"name":"tutorials point"})` y `show dbs` para ver las tablas creadas.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Persisitiendo Data con Jenkins

--------------------------------------------------------------------------

Usaremos el comando de descarga del repositorio de **Jenkins** `docker pull jenkins`.

Para correr la imagen de **jenkins** descargada usaremos el comando siguiente `docker run -d --name <container-name> -p <machine-port>:<container-port> -v <location-volumen-machine>:<location-volumen-container> <image-name>:<image-tag>`, `docker run -d --name jenkins-data -p 8080:8080 -v /opt/jenkins/:/var/jenkins_home`.

Si buscamos en la documentación oficial de mongo veremos que guarda su contenido creado dentro de `/var/jenkins_home`.

> Nota: Previamente será necesario crear la carpeta `/opt/jenkins/`que será dónde se guaradrá nuestro volumen.

Accedemos a [http://localhost:8080](http://localhost:8080), podemos crear algo de contenido y probar que verdaderamnete se guardó.

> Nota: jenkins requiere que accedamos a su contenedor para visualizar el pass que nos permita loguearnos en la instalación. Para acceder a ver dicho contenido sin entrar dentro del contenedor podemos ejecutar la siguiente línea `docker exec <container-name> bash -c "<command-container>"`, en nuestro caso sería `docker exec jenkins-data bash -c "cat /var/jenkins_home/secrets/initialAdminPassword"`, y veremos el resultado del contenedor.

Una vez creado el contenido, eliminamos el contenedor `docker rm -fv jenkins` y lo volvemos a crear referenciando la carpeta del volumen `docker run -d --name jenkins-data -p 8080:8080 -v /opt/jenkins/:/var/jenkins_home`. 

Ahora si accedemos al proyecto, [http://localhost:8080](http://localhost:8080), veremos que no se perdió nada.

--------------------------------------------------------------------------

### Compartir Volúmenes entre varios contenedores

--------------------------------------------------------------------------

Generamos una carpeta llamada **/common/** dónde guardaremos el volumen común.

Primeramente definimos nuestra imagen sigueinte dentro de **Dockerfile**

_[Dockerfile](./Dockerfile)_
```dockerfile
FROM centos
COPY start.sh /start
RUN chmod +x /start.sh
CMD /start.sh
```

y nuestro CMD que creará dentro de index.html cada diez segundos una línea con la hora de ese instante.

_[start.sh](./start.sh)_
```sh
#!/bin/bash
while true; do
    echo "<p>$(date +%H:%M:%S)</p>" > /opt/index.html
    sleep 10
done
```

Una vez creado todo lo necesario para nuestra imagen la creamos con el comando `docker build -t test .`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker build -t test .
Sending build context to Docker daemon  3.072kB
Step 1/4 : FROM centos
 ---> 75835a67d134
// ...
Successfully tagged test:latest
```

Ahora podemos lanzar el contenedor que guarde el volumen generado dentro de `/opt` en la carpeta de ubicación (`$PWD`) `/common`, usando el comando `docker run -v $PWD/common:/opt -d --name generator test`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -v $PWD/common:/opt -d --name generator test
712baa13eb8fa9ba0756921a51ba956e815ecdb39c1b3f62bd02479de59b119e
```

Nos aseguramos que el contenedor está corriendo `docker ps`.

```bash
demo@VirtualBox:~/Demo_Docker$  docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED              STATUS              PORTS         NAMES
712baa13eb8f        test                "/bin/sh -c /start.sh"   About a minute ago   Up About a minute         generator
```

Y vemos el archivo generado **index.html** usando `cat common/index.html`.

```bash
demo@VirtualBox:~/Demo_Docker$ cat common/index.html
<p>19:40:08</p>
<p>19:40:18</p>
<p>19:40:28</p>
<p>19:40:38</p>
<p>19:40:48</p>
<p>19:40:58</p>
<p>19:41:08</p>
<p>19:41:18</p>
```

Ya podemos generar nuestra segundo contenedor `docker run -d --name nginx -v $PWD/common:/usr/share/nginx/html -p 80:80 nginx:alpine` que utilizará el mismo volumen para guardar sus datos.

Si entrasemos en [http://localhost:80](http://localhost:80) veríamos en el navegador a index.html.

> nuestro contenedor generador iría modificando index.html, y nginex lo serviría.

