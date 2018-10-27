--------------------------------------------------------------------------

### Crear Contenedor con Mongo

--------------------------------------------------------------------------

Usaremos el comando de descarga del repositorio de **Mysql** `docker pull mongo`.

Para correr la imagen de mongo descargada usaremos el comando siguiente `docker run  -d  --name <container-name> -p <machine-port>:<container-port> <image-name>:<image-tag>`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name my-mongo -p 8081:27017 mongo
6a32e52277c49ad5b2346519e76d811294059cd9ffd420073bf1f1891bcea6e6

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE      COMMAND                 CREATED          STATUS        PORTS               NAMES
b6d4aafaa13e  mysql:5.7  "docker-entrypoint.s…"  40 minutes ago   Up 40 minutes 3306/tcp, 33060/tcp my-dbl
hector@hector-VirtualBox:~/docker_by_sample$
```

Para ver que consumo tiene un contenedor ejecutaremos `docker stats my-mongo`

```bash
demo@VirtualBox:~/Demo_Docker$ docker stats my-mongo

CONTAINER ID  NAME      CPU %  MEM USAGE / LIMIT     MEM %   NET I/O      BLOCK I/O       PIDS
6d320f9c3e30  my-mongo  0.29%  39.87MiB / 6.313GiB   0.62%   4.21kB / 0B  164kB / 1.11MB  26
```

Si tuvieramos un cliente para mongo podríamos ver nuestra base de datos para mongo.