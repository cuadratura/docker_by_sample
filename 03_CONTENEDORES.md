
> IMPORTANTE: 
* **Los contenedores son una instancia de ejecución de una imagen, es decir traen a ejecución todas las capas de la imagen.**
* **Los contenedores son temporales. NUNCA debemos hacer cambios en el contenedor ya que estos son temporales y de hacerlo al eliminar el contenedor desapareceran esos cambios**
* **Las contenedor son instancias de las imágenes con una capa de lectura y escritura, siendo la de lectura la perteneciente a la imagen ya creada.**
* **Podemos crear infinitos contenedores a partir de una misma imagen, la imagen simplemente sirve como plantilla del contenedor.**


--------------------------------------------------------------------------

### Listar y Mapear Contenedores

--------------------------------------------------------------------------

Para ello utilizaremos el comando `docker ps` para los contenedores que están corriendo en ese instante, y `docker ps -a`para los contenedores que estan corriendo más los ya muertos.

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE      COMMAND           CREATED        STATUS       PORTS       NAMES
demo@VirtualBox:~/Demo_Docker$ docker ps -a
CONTAINER ID  IMAGE      COMMAND           CREATED        STATUS       PORTS       NAMES
```

En nuestro caso no tendríamos ningun contenedor corriendo o muerto recientemente.

--------------------------------------------------------------------------

### Crear un Contenedor nuevo

--------------------------------------------------------------------------

> Nota: Usaremos `docker run --help|less` para poder visualizar todas las opciones de este comando.

`docker run -d <image-name>:<image-tag>` correrá el contenedor en segundo plano. Para nustro caso usaremos la imagen oficial de **jenkins** previa descarga (`docker pull jenkins`).

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d jenkins
e30e0d57b59115ae6032d9ed209436f8c2bcb54dd4c232732fc0a94687bf5a90

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE    COMMAND        CREATED        STATUS       PORTS                NAMES
e30e0d57b591  jenkins  "/bin/tini …"  7 seconds ago  Up 4 seconds 8080/tcp, 50000/tcp  peaceful_torvalds

demo@VirtualBox:~/Demo_Docker$
```

En el extracto anterior podemos ver: el **id** del contenedor, la **imagen** usada, los **comandos**, los **puertos** empleados y el **nombre**, en este caso generado aleatoriamente.

Ahora si intentaramos acceder a [http://localhost:8080](http://localhost:8080) veremos que NO tenemos acceso a jenkins, esto es debido a que en este contenedor no hemos mapeado los puertos.

--------------------------------------------------------------------------

### Mapeo de puertos

--------------------------------------------------------------------------

Creamos un puerto alternativo a partir de esa imagen anterior mediante `docker run -d -p 8080:8080 jenkins`. Así mapearemos nuestro puerto `8080` con respecto al del contenedor `8080`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d -p 8080:8080 jenkins
c0c9aa57119569fdc41e8a41c98b8fdcaf14d8d5c7f9de40efb9afc7599ccf64

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                      NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Up 3 seconds 0.0.0.0:8080->8080/tcp,    serene_brown
                                                                 50000/tcp   
e30e0d57b591 jenkins  "/bin/tini …"  7 seconds ago  Up 4 seconds 8080/tcp, 50000/tcp        peaceful_torvalds

demo@VirtualBox:~/Demo_Docker$
```

Podemos ver como `0.0.0.0:8080->8080/tcp`el puerto `8080` se mapeo ya con el del contenedor en la nueva imagen `serene_brown`.

Ahora si accedemos a [http://localhost:8080](http://localhost:8080) veremos que tenemos acceso a jenkins.

--------------------------------------------------------------------------

### Borrar contenedores

--------------------------------------------------------------------------

Para parar un contenedor que está corriendo usaremos el comando `docker rm -f <container-name>`, en nuestro caso podríamos usar `docker rm -f serene_brown peaceful_torvalds`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                      NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Up 3 seconds 0.0.0.0:8080->8080/tcp,    serene_brown
                                                                 50000/tcp   
e30e0d57b591 jenkins  "/bin/tini …"  7 seconds ago  Up 4 seconds 8080/tcp, 50000/tcp        peaceful_torvalds

demo@VirtualBox:~/Demo_Docker$ docker rm -f serene_brown peaceful_torvalds

demo@VirtualBox:~/Demo_Docker$ docker ps
```

> **¿Cómo podemos eliminar todos los contenedores que estén corriendo con un solo comando?** Para ello usaríamos `docker ps -q | xargs docker rm -f`



--------------------------------------------------------------------------

### Renombrar un contenedor

--------------------------------------------------------------------------

Para renombrer un contenedor usaremos el comando `docker rename <filename-old> <dilename-new>`, por ejemplo sería `docker rename serene_brown jenkins-v1`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d -p 8080:8080 jenkins
c0c9aa57119569fdc41e8a41c98b8fdcaf14d8d5c7f9de40efb9afc7599ccf64

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Up 3 seconds 0.0.0.0:8080->8080/tcp, 50000/tcp serene_brown

demo@VirtualBox:~/Demo_Docker$ docker rename serene_brown jenkins-v1

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Up 3 seconds 0.0.0.0:8080->8080/tcp, 50000/tcp jenkins-v1
```

> Nota: los nombres de los contenedores no pueden repetirse.

--------------------------------------------------------------------------

### Iniciar, Parar y Reiniciar un contenedor

--------------------------------------------------------------------------

Para detener un contenedor usaremos el comando `docker stop <container-id>` o el comando `docker stop <container-name>`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d -p 8080:8080 jenkins
c0c9aa57119569fdc41e8a41c98b8fdcaf14d8d5c7f9de40efb9afc7599ccf64

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Up 3 seconds 0.0.0.0:8080->8080/tcp, 50000/tcp jenkins-v1

demo@VirtualBox:~/Demo_Docker$ docker stop jenkins-v1

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES

demo@VirtualBox:~/Demo_Docker$ docker ps -a
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Exited (143) 0.0.0.0:8080->8080/tcp, 50000/tcp jenkins-v1
```

Para iniciarlo usaremos el comando `docker start <container-id>` o el comando `docker start <container-name>`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES

demo@VirtualBox:~/Demo_Docker$ docker ps -a
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Exited (143) 0.0.0.0:8080->8080/tcp, 50000/tcp jenkins-v1

demo@VirtualBox:~/Demo_Docker$ docker start jenkins-v1

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Up 3 seconds 0.0.0.0:8080->8080/tcp, 50000/tcp jenkins-v1
```

Para reiniciarlo usaremos el comando `docker restart <container-id>` o el comando `docker restart <container-name>`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Up 3 seconds 0.0.0.0:8080->8080/tcp, 50000/tcp jenkins-v1

demo@VirtualBox:~/Demo_Docker$ docker restart jenkins-v1

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Up 3 seconds 0.0.0.0:8080->8080/tcp, 50000/tcp jenkins-v1
```

--------------------------------------------------------------------------

### Ingresar en el contenedor

--------------------------------------------------------------------------

Para acceder a la terminal del contenedor iniciado usaremos `docker exec -ti <container-name> bash`, como por ejemplo `docker exec -ti jenkins-v1 bash`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Up 3 seconds 0.0.0.0:8080->8080/tcp, 50000/tcp jenkins-v1

demo@VirtualBox:~/Demo_Docker$ docker exec -ti jenkins-v1 bash

jenkins-v1@c0c9aa571195:/$
```

Ahora estamos dentro del contenedor.

Si escribieramos `whoami` en el mismo veríamos que el usuario ahora es `jenkins-v1`.

```bash
jenkins-v1@c0c9aa571195:/$ whoami
jenkins-v1

jenkins-v1@c0c9aa571195:/$ hostname
c0c9aa571195

jenkins-v1@c0c9aa571195:/$ 
```

Para salir de la terminal del contenedor ejecutaremos `exit`.

```bash
jenkins-v1@c0c9aa571195:/$ exit
exit

demo@VirtualBox:~/Demo_Docker$ 
```

Si quisieramos cambiar el usuario del contenedor usaríamos en cambio el comando `docker exec -u <user-name> -ti <container-name> bash`, como por ejemplo `docker exec -u root -ti jenkins-v1 bash`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE    COMMAND        CREATED        STATUS       PORTS                             NAMES
c0c9aa571195 jenkins  "/bin/tini …"  4 seconds ago  Up 3 seconds 0.0.0.0:8080->8080/tcp, 50000/tcp jenkins-v1

demo@VirtualBox:~/Demo_Docker$ docker exec -u root -ti jenkins-v1 bash

root@c0c9aa571195:/$ whoami
root
```

> **¿Para que puede ser interesante entrar dentro de la terminal del contenedor?** Por ejemplo para inicalizar jenkins deberemos entrar dentro para obtener una key que nos permita loguearnos.

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec -ti jenkins-v1 bash

jenkins-v1@c0c9aa571195:/$ cat /var/jenkins_home/secrets/initialAdminPassword
123bn41o234b5p1b54145kb12345

jenkins-v1@c0c9aa571195:/$ exit
exit

demo@VirtualBox:~/Demo_Docker$
```

> **¿Para que puede ser interesante entrar como usuario root dentro de la terminal del contenedor?** Por ejemplo crear archivos e incluso leerlos (al igual que en sistema operativo sobre el que esté montada la imagen)

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec -u root -ti jenkins-v1 bash

root@c0c9aa571195:/$ echo "test" > /tmp/test
root@c0c9aa571195:/$ chmod 400 /tmp/test
root@c0c9aa571195:/$ cat /tmp/test
test

root@c0c9aa571195:/$ exit
exit

demo@VirtualBox:~/Demo_Docker$ docker exec -ti jenkins-v1 bash
jenkins-v1@c0c9aa571195:/$ cat /tmp/test
cat: /tmp/test: Permission denied

root@c0c9aa571195:/$ exit
exit

demo@VirtualBox:~/Demo_Docker$
```

--------------------------------------------------------------------------

### Variables de Entorno

--------------------------------------------------------------------------

Se pueden definir en dos lugares: 

**dentro de la definición de la propia imagen generada**

_[Dockerfile](./Dockerfile)_
```dockerfile
FROM centos
ENV prueba 1234
RUN useradd ricardo
```

```bash
docker build -t env:v1 .
docker run -dti --name env env:v1
docker ps
docker exec -u ricardo -ti 23kukvb1234 bash
echo $env
echo $prueba
exit
docker run -dti -e "prueba1=4321" --name env-v2 env:v1
docker exec -u ricardo -ti wdfg234t2g2g bash
# env
```
