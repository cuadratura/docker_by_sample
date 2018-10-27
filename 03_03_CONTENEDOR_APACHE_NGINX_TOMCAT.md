--------------------------------------------------------------------------

### Crear Contenedor con Nginx

--------------------------------------------------------------------------

Usaremos el comando de descarga del repositorio de **Nginx** `docker pull nginx`.

Para correr la imagen de mongo descargada usaremos el comando siguiente `docker run -d  --name <container-name> -p <machine-port>:<container-port> <image-name>:<image-tag>`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name nginx-v1 -p 8888:80 nginx
6a32e52277c49ad5b2346519e76d811294059cd9ffd420073bf1f1891bcea6e6

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE  COMMAND                CREATED        STATUS        PORTS        NAMES
46f863efd2a6  nginx  "nginx -g 'daemon of…" 4 seconds ago  Up 3 seconds  0.0.0.0:...  nginx-v1
demo@VirtualBox:~/Demo_Docker$
```

Si accedemos en nuestro navegador a [http://localhost:8888/](http://localhost:8888/) veremos que tenemos corriendo en ese puerto a **nginx**.

--------------------------------------------------------------------------

### Crear Contenedor con Apache

--------------------------------------------------------------------------

Usaremos el comando de descarga del repositorio de **Apache** `docker pull httpd`.

Para correr la imagen de mongo descargada usaremos el comando siguiente `docker run -d  --name <container-name> -p <machine-port>:<container-port> <image-name>:<image-tag>`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name apache-v1 -p 9999:80 httpd
6a32e52277c49ad5b2346519e76d811294059cd9ffd420073bf1f1891bcea6e6

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE  COMMAND             CREATED        STATUS        PORTS    NAMES
2d84b12f5e24  httpd  "httpd-foreground"  49 seconds ago Up 47 seconds 0.0...   apache-v1
demo@VirtualBox:~/Demo_Docker$
```

Si accedemos en nuestro navegador a [http://localhost:9999/](http://localhost:9999/) veremos que tenemos corriendo en ese puerto a **apache**.

--------------------------------------------------------------------------

### Crear Contenedor con Tomcat

--------------------------------------------------------------------------

Usaremos el comando de descarga del repositorio de **Tomcat** `docker pull tomcat:9.0.8-jre8-alpine`.

Para correr la imagen de mongo descargada usaremos el comando siguiente `docker run -d --name <container-name> -p <machine-port>:<container-port> <image-name>:<image-tag>`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name tomcat-v1 -p 7070:8080 tomcat:9.0.8-jre8-alpine
6a32e52277c49ad5b2346519e76d811294059cd9ffd420073bf1f1891bcea6e6

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE                     COMMAND     CREATED  STATUS        PORTS      NAMES
9375581dbf4e  tomcat:9.0.8-jre8-alpine  "catali.."  6 se...  Up 3 seconds  0.0....    tomcat-v1
```

Si accedemos en nuestro navegador a [http://localhost:7070/](http://localhost:7070/) veremos que tenemos corriendo en ese puerto a **tomcat**.