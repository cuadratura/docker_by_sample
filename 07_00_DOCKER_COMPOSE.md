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

Y ejecutamos `docker-compose up -d` para lanzar el contenedor.

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

--------------------------------------------------------------------------

### Volúmenes | Host

--------------------------------------------------------------------------
