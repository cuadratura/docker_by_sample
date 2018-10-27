--------------------------------------------------------------------------

### Crear Contenedor con Mysql

--------------------------------------------------------------------------

Usaremos el comando de descarga del repositorio de **Mysql** `docker pull mysql`.


--------------------------------------------------------------------------

> Para esté ejercicio es necesario tener instalado el cliente mysql de ubuntu [https://linuxconfig.org/install-mysql-on-ubuntu-18-04-bionic-beaver-linux](https://linuxconfig.org/install-mysql-on-ubuntu-18-04-bionic-beaver-linux).

Hemos usado los comandos:
* `sudo apt install mysql-client`, para instalar el cliente mysql en ubuntu 18.04.
```bash
demo@VirtualBox:~/Demo_Docker$ sudo apt install mysql-client
[sudo] password for hector:
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following additional packages will be installed:
// ...
Setting up mysql-client (5.7.24-0ubuntu0.18.04.1) ...
Processing triggers for libc-bin (2.27-3ubuntu1) ...
```
* `mysql -V`, para confirmar la versión instalada.
```bash
demo@VirtualBox:~/Demo_Docker$ mysql -V
mysql  Ver 14.14 Distrib 5.7.24, for Linux (x86_64) using  EditLine wrapper
```
* Para conectar remotamente MySQL server se usará el siguiente comando `msql -u USERNAME -p PASSWORD -h HOST-OR-SERVER-IP`

--------------------------------------------------------------------------


Si leemos la documentación oficial de la imagen veremos que necesitamos del siguiente comando para crear el contenedor a partir de la imagen **Mysql** `docker run --name <container-name> -e MYSQL_ROOT_PASSWORD=<pass-root> -d <image-name>:<image:tag>`. 

En nuestro caso usaríamos `docker run --name my-dbl -e "MYSQL_ROOT_PASSWORD=123456" -d mysql:5.7`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run --name my-dbl -e "MYSQL_ROOT_PASSWORD=123456" -d mysql:5.7
ae123e43f275375661cc07424807d2448fc5ccf8ce6a99d249b0e7adcd7e5d92
```

Ahora podremos ver el contenedor corriendo con el nombre designado:

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                 NAMES
ae123e43f275        mysql:5.7           "docker-entrypoint.s…"   19 minutes ago      Up 19 minutes       3306/tcp, 33060/tcp   my-dbl
```

Y podremos acceder al proceso usando `docker logs -f <container-name>`

```bash
demo@VirtualBox:~/Demo_Docker$ docker logs -f my-dbl
Initializing database
2018-10-27T11:44:50.148327Z 0 [Warning] // ...
2018-10-27T11:45:03.891600Z 0 [Note] mysqld: ready for connections.
Version: '5.7.24'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
```

Podremos ver que nuestra contenedor con la imagen **mysql** está ya lista y correindo en el puerto 3306.

Ahora ejecutaremos el `mysql -u root -p123456`, y veremos el siguiente error:

```bash
demo@VirtualBox:~/Demo_Docker$ mysql -u root -p 123456
Enter password:
ERROR 2002 (HY000): Can't connect to local MySQL server through socket '/var/run/mysqld/mysqld.sock' (2)
``` 

Este error indica que no podremos conectarnos a un mysql local ya que no se definió (`docker run --name my-dbl -e "MYSQL_ROOT_PASSWORD=123456" -d mysql:5.7`)

> **¿Cómo definiremos el puerto solicitado?**

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE      COMMAND                 CREATED         STATUS         PORTS                 NAMES
ae123e43f275  mysql:5.7  "docker-entrypoint.s…"  29 minutes ago  Up 29 minutes  3306/tcp, 33060/tcp   my-dbl

demo@VirtualBox:~/Demo_Docker$ docker inspect my-dbl
[
    {
        "Id": "ae123e43f275375661cc07424807d2448fc5ccf8ce6a99d249b0e7adcd7e5d92",
        // ...
                    "IPAddress": "172.17.0.2",
        // ...
                }
            }
        }
    }
]
demo@VirtualBox:~/Demo_Docker$ 
```

Tomamos la Ip del contenedor, en este caso `"IPAddress": "172.17.0.2",` ahora ejecutaremos `mysql -u root -h 172.17.0.2 -p123456` indicando la ip del contenedor.

```bash
demo@VirtualBox:~/Demo_Docker$ mysql -u root -h 172.17.0.2 -p123456
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.24 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

mysql> show database
    ->
```

Ya estaremos dentro de mysql y podremos ver el listado de bases de datos existentes mediante el comando mysql `show database`.


#### Creamos un contenedor 

Usaremos el comando `docker run -p 3333:3306 --name my-db2 -e "MYSQL_ROOT_PASSWORD=123456" -e "MYSQL_DATABASE=docker-db" -e "MYSQL_USER=docker-user" -e "MYSQL_PASSWORD=87654321" -d mysql:5.7`, que difinirá un contenedor a partir de la imagen de mysql llamado (`my-db2`) y que en cambio mapeará nuestro puerto (`3333`) con el del contenedor (`3306`) (mysql). Este contenedor se creará en segundo plano (`-d`), y dispondrá de tres variables de entorno nuevas que generaran una base de datos (`"MYSQL_DATABASE=docker-db"`), un usuario (`"MYSQL_USER=docker-user"`) y un password de acceso (`"MYSQL_PASSWORD=87654321"`).

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -p 3333:3306 --name my-db2 -e "MYSQL_ROOT_PASSWORD=123456" -e"MYSQL_DATABASE=docker-db" -e "MYSQL_USER=docker-user" -e "MYSQL_PASSWORD=87654321" -d mysql:5.7
7010a9e0b0930da3a59e9ef644d34d7f3c9dae97a5ccf8b19cc2fcd991958851

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE      COMMAND                 CREATED        STATUS      PORTS NAMES
7010a9e0b093  mysql:5.7  "docker-entrypoint.s…"  5 seconds ago  Up 4 second 33060/tcp, 0.0.0.0:3333->3306/tcp my-db2
```

Para acceder a ver el estado del contenedor ejecutaremos el comando `docker logs -f my-db2`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker logs -f my-db2
Initializing database
2018-10-27T11:44:50.148327Z 0 [Warning] // ...
2018-10-27T11:45:03.891600Z 0 [Note] mysqld: ready for connections.
Version: '5.7.24'  socket: '/var/run/mysqld/mysqld.sock'  port: 3306  MySQL Community Server (GPL)
```

Debemos recordar que el puerto `3306` del contenedor se mapeó con el de nuestra máquina por el `3333`.

Y lanzamos el comando de acceso a nuestro contenedor tal que así: `

```bash
demo@VirtualBox:~/Demo_Docker$ mysql -u root -p123456 -h 127.0.0.1 --port 3333
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.24 MySQL Community Server (GPL)

Copyright (c) 2000, 2018, Oracle and/or its affiliates. All rights reserved.

Oracle is a registered trademark of Oracle Corporation and/or its
affiliates. Other names may be trademarks of their respective
owners.

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
5 rows in set (0.00 sec)
```

Probamos además que el usuario y su contraseña funcionan.

```bash
demo@VirtualBox:~/Demo_Docker$ mysql -u docker-user -p87654321 -h 127.0.0.1 --port 3333
mysql: [Warning] Using a password on the command line interface can be insecure.
Welcome to the MySQL monitor.  Commands end with ; or \g.
Your MySQL connection id is 2
Server version: 5.7.24 MySQL Community Server (GPL)
// ...
```