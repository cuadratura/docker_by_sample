# Summary Commands




-------------------------

## Linux

-------------------------

* `du -sh <file-name-with-location>` muestra el tamaño del archivo
* `cat <file-name-with-location>`, muestra en consola el contenido del archivo.
* `cat <file-name-with-location> | less`, muestra en consola el contenido del archivo paginado.
* `vi <file-name-with-location>`, abre el editor en consola del archivo.
* `echo <content-text>`, imprime contenido.
* `mkdir <folder-name>`, crea un directorio.
* `sudo chown 1000 -R <folder-location>`, por ejemplo `sudo chown 1000 -R ~/jenkins`. Otorga permisos de edición y ejecución.
* `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout <mysitename>.key -out <mysitename>.crt`, por ejemplo `openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout docker.key -out docker.crt` 

* Nota: (AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message), [https://medium.com/@ThilinaAshenGamage/port-forwarding-for-ssh-http-on-virtualbox-459277a888be](https://medium.com/@ThilinaAshenGamage/port-forwarding-for-ssh-http-on-virtualbox-459277a888be)

# https in apache



-------------------------

## Images

-------------------------

* `docker build --tag <image-name>:<tag-name> <location>`, por ejemplo `docker build --tag apache-centos .` o `docker build --tag apache-centos /var/www/html` (si estuviera )
* `docker rmi $(docker images -q)`, elimina todas las imágenes existentes
* `docker images`, mostrar el listado de imágenes

* `docker history -H <image-name>`, por ejemplo `docker history -H apache-centos`, muestra el historial de capas de la imagen.

-------------------------

## Container

-------------------------

* `docker ps`, muestra los contenedores en ejecución o vivos.
* `docker ps -a`, muestra los contenedores que han estado vivos y los muertos.
* `docker ps --no-trunc`, muestra los contenedores en ejecución o vivos, sin truncar los datos (los muestra enteros).
* `docker ps -a --no-trunc`, muestra los contenedores que han estado vivos y los muertos, sin truncar los datos (los muestra enteros).

* `docker run -d --name <container-name> -p <port-machine>:<port-container> <image-name>:<tag-name>`, por ejemplo `docker run -d --name apache-centos -p 80:80 apache-centos`, lanza crea un contenedor con nombre <container-name> a partir de la imagen indicada <image-name>.

* `docker rm -fv <container-name>`, por ejemplo `docker rm -fv apache-centos-user`, elimina un contenedor lanzado.

* `docker logs -f <container-name>` por ejemplo `docker logs -f apache-centos-user`, muestra los errores ocurridos al lanzar un contenedor.


# DockerFile Buenas prácticas

* La imagen o el servicio instaado deben ser efimeros - Efímeros. Debe ser destruible facilmente.
* Debe haber un solo servicio (CMD) por contenedor
* Utilizar docker ignore si no quieres que docker cargue ciertos archivos innecesarios.
* Utilizar las capas justas y necesarias
* Separar argumentos en diferentes líneas
* Pasar varios argumentos en una sola capa en lugar de escribirlas en diferentes capas
* No instalar paquetes innecesarios
* Usar labels, para incluir metadatos