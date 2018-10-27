> Los volúmenes permiten almacenar data persistente del contenedor, en caso de que el contenedor se elimine. Es muy útil para contendores de bases de datos.

Existen tres tipos de volúmenes:
* **Host**, son volúmenos que se almacenan dentro de nuestro **dockerhost** y se almacenan en una carpeta de nuestro docker file que nosotros definimos previamente.
* **Anonymus**, no se definen en una carpeta, pero docker los guarda en una capreta random
* **Named Volumnes**, no son carpetas administradas por docker, peroa  diferencias de **Anonymus** disponen de un nombre.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

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
root@VirtualBox:~/Demo_Docker$ docker logs -f my-db
Initializing database
2018-10-27T16:45:14.283612Z 0 [Warning] TIMESTAMP with implicit 
// ...
2018-10-27T16:45:28.911040Z 0 [Note] mysqld: ready for connections.
Version: '5.7.24'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)

root@VirtualBox:~/Demo_Docker$ 
```

Accedemos a mysql `mysql -u root -h 127.0.0.1 -p` e introduciremos el password del root indicado al montar el contenedor `12345678`.

```bash
root@VirtualBox:~/Demo_Docker$ mysql -u root -h 127.0.0.1 -p
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
root@VirtualBox:~/Demo_Docker$ mysql -u root -h 127.0.0.1 -p docker-db < dump.sql
Enter password:
```

Volvemos a conectar con **docker-db** para ver su contenido, `mysql -u root -h 127.0.0.1 -p docker-db`

```bash
root@VirtualBox:~/Demo_Docker$ mysql -u root -h 127.0.0.1 -p docker-db
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
