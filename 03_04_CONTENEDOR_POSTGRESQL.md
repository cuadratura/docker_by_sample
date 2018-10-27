--------------------------------------------------------------------------

### Crear Contenedor con PostGradeSQL

--------------------------------------------------------------------------

Usaremos el comando de descarga del repositorio de **PostGradeSQL** `docker pull postgrades`.

Para correr la imagen de mongo descargada usaremos el comando siguiente `docker run -d --name <container-name> -p <machine-port>:<container-port> <image-name>:<image-tag>`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name postgres-v1 -e "POSTGRES_PASSWORD=12345678" -e "POSTGRES_USER=docker" -e "POSTGRES_DB=docker-db" -p 5432:5432 postgres
bb042dd753df8f3a41525703887688895161794612fd389837e1e397488d89d3

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE    COMMAND   CREATED   STATUS    PORTS                   NAMES
bb042dd753df  postgres "docke…"  17 min... Up 17 m.. 0.0.0.0:5432->5432/tcp  postgres-v1
```

Ahora accedemos a la terminal del contenedor mediante `docker exec -ti postgres-v1 bash`

Y ejecutamos `psql -d docker-db -U docker` para entrar en postgresSql.

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec -ti postgres-v1 bash
root@bb042dd753df:/# psql -d docker-db -U docker
psql (11.0 (Debian 11.0-1.pgdg90+2))
Type "help" for help.

docker-db= \l
```

Si escribimos `\l` veremos las bases de datos creadas dentro de postgresSQL.