# Resumen de Comandos en Docker

> **NOTA**: Para acceder al `Document Root de Docker` necesitamos estar logueado como administrador `sudo su`, para posteriormente mediante el comando `docker info | grep -i root` visualizar la carpeta dónde se aloja toda la información de docker `Docker Root Dir: /var/lib/docker`.

## IMÁGENES

--------------------------------------------------------------------------

* Listar imágenes, `docker images`
* Listar imágenes con filtro `docker images | grep <filter>`
* Listar imágenes con filtro `docker images -f <tilter>=true`
* Listar imágenes huerfanas, `docker images -f dangling=true`
* Construir imagen, `docker build -t <image-name>:<image-tag> -f <new-dockerfile-name> <location>`

* Eliminar imagen, `docker rmi <image-name>:<image-tag>` o `docker rmi <image-id>`
* Eliminar todas las imágenes huerfanas `docker images -f dangling=true -q | xargs docker rmi`

## CONTENEDORES

--------------------------------------------------------------------------

* Listar contenedores en ejecución, `docker ps`
* Listar contenedores recientes, `docker ps -a`
* Para crear un contenedor:
  * `docker run -d <image-name>:<image-tag>`
  * `docker run -d --name <container-name> -p <por-machine>:<port-container> <image-name>:<image-tag>`
  * `docker run -d --name <container-name> -p <por-machine>:<port-container> -e "<variable-environment-name>=<variable-environment-value>" <image-name>:<image-tag>`
  * `docker run -d --name <container-name> -p <por-machine>:<port-container> -v  <folder-volume-machine>:<folder-volume-container> <image-name>:<image-tag>`
    * `docker run -d --network <network-name> --name <container-name> -p <por-machine>:<port-container> -v  <folder-volume-machine>:<folder-volume-container> <image-name>:<image-tag>`
* Renombrar contenedor, `docker rename <filename-old> <dilename-new>`
* Parar contenedor, `docker stop <container-id>` o `docker stop <container-name>`
* Iniciar Contenedor, `docker start <container-id>` o `docker start <container-name>`
* Reiniciar Contenedor, `docker restart <container-id>` o `docker restart <container-name>`
* Borrar todos los contenedore, `docker rm -fv $(docker ps -aq)`
* Eliminar contenedor, `docker rm -f <container-name>`
* Acceder dentro de un contenedor, `docker exec -ti <container-name> bash`
* Estad´siticas de un contenedor, `docker stats <container-name>`
* Limitar recursos contenedor:
  * Limitar memoria, `docker run -d -m <limit-memory> --name <new-container-name> -p <port-machine>:<port-container> <image-name>`, por ejemplo `docker run -d -m "500mb" --name my-mongo-2 -p 8081:27017 mongo`.
  * Limitar cpu, `docker run -d -m <limit-memory> --name <new-container-name> --cpuset-cpus <range-cpu> -p <port-machine>:<port-container> <image-name>`, por ejemplo `docker run -d -m "500mb" --name my-mongo-3 --cpuset-cpus 0-1 -p 8081:27017 mongo`.
* Copiar contenido en el contenedor, `docker cp <file-to-copy> <container-name>:/tmp`
* Docker commit, `docker commit <container-name> <new-image-name>` por ejemplo `docker commit centos centos-commit`
* Mostrar el estado de la construcción del contenedor `docker logs -f <ontainer-name>`
* Inspeccionar contenedor, `docker inspect <container-name> 
* Ejecutar comando consola en contenedor, `docker exec <container-name> bash -c "<command-container>"`

## VOLÚMENES

--------------------------------------------------------------------------

* Crear volumen `docker volume create <volume-name>`
* Listar volúmenes, `docker volume ls`
* Listar volúmenes anónimos, `docker volume ls -f dangling=true`
* Eliminar todos los volúmenes huérfanos, `docker volume ls -f dangling=true -q | xargs docker volume rm`

## REDES

--------------------------------------------------------------------------

* Ayuda Network, `docker network --help`
* Inspeccionar Network, `docker inspect network <network-name>`
* Crear una red, `docker network create <network-name>`
* Listar Networks, `docker network ls`
* Listar Networks con filtro, `docker network ls | grep <filter>`
* Agregar contenedores, `docker run -d --name <network-name> <container-name>`
* Conectar contenedor existente a una red distinta, `docker network connect <network-to-connect> <container-name-to-connect>`
* Desconectar red `docker network disconnect <network-name>`
* Eliminar red, `docker network rm <network-name>`
