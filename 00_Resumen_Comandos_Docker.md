# Imágenes

* Listar imágenes, `docker images`
* Listar imágenes con filtro `docker images | grep <filter>`
* Listar imágenes con filtro `docker images -f <tilter>=true`
* Listar imágenes huerfanas, `docker images -f dangling=true`
* Construir imagen, `docker build -t <image-name>:<image-tag> -f <new-dockerfile-name> <location>`

* Eliminar imagen, `docker rmi <image-name>:<image-tag>` o `docker rmi <image-id>`
* Eliminar todas las imágenes huerfanas `docker images -f dangling=true -q | xargs docker rmi`

# Contenedores

* Listar contenedores en ejecución, `docker ps`
* Listar contenedores recientes, `docker ps -a`
* Para crear un contenedor:
  * `docker run -d <image-name>:<image-tag>`
  * `docker run -d --name <container-name> -p <por-machine>:<port-container> <image-name>:<image-tag>`
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
