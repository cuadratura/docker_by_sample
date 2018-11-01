
> IMPORTANTE: 
* **Los contenedores son una instancia de ejecución de una imagen, es decir traen a ejecución todas las capas de la imagen.**
* **Los contenedores son temporales. NUNCA debemos hacer cambios en el contenedor ya que estos son temporales y de hacerlo al eliminar el contenedor desapareceran esos cambios**
* **Las contenedor son instancias de las imágenes con una capa de lectura y escritura, siendo la de lectura la perteneciente a la imagen ya creada.**
* **Podemos crear infinitos contenedores a partir de una misma imagen, la imagen simplemente sirve como plantilla del contenedor.**


--------------------------------------------------------------------------

### Listar y Mapear Contenedores

--------------------------------------------------------------------------

Para ello utilizaremos el comando `docker ps` para los contenedores que están corriendo en ese instante, y `docker ps -a` para los contenedores que estan corriendo más los ya muertos.

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

Podemos ver como `0.0.0.0:8080->8080/tcp` el puerto `8080` se mapeo ya con el del contenedor en la nueva imagen `serene_brown`.

Ahora si accedemos a [http://localhost:8080](http://localhost:8080) veremos que tenemos acceso a jenkins.

--------------------------------------------------------------------------

### Eliminar contenedores

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

> **¿Cómo podemos eliminar todos los contenedores que estén corriendo con un solo comando?** Para ello usaríamos `docker rm -fv $(docker ps -aq)`.

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

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

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

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

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
demo@VirtualBox:~/Demo_Docker$ docker build -t env:v1 .
Sending build context to Docker daemon  2.048kB
Step 1/3 : FROM centos
// ...
Successfully tagged env:v1

demo@VirtualBox:~/Demo_Docker$ docker run -dti --name env env:v1
2e1105498284b08d0bb503c4c06d429654cfaa7d41234fafcbfc297b628b0fc0

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE   COMMAND     CREATED          STATUS        PORTS   NAMES
2e1105498284  env:v1  "/bin/bash" 10 seconds ago   Up 9 seconds          env

demo@VirtualBox:~/Demo_Docker$ docker exec -u ricardo -ti env bash

[ricardo@2e1105498284 /]$ echo $env

[ricardo@2e1105498284 /]$ echo $prueba
1234

[ricardo@2e1105498284 /]$ exit
exit

demo@VirtualBox:~/Demo_Docker$ docker run -dti -e "prueba1=4321" --name env-v2 env:v1
8e152e4487816aa5b60c6401bd06a01ae95bd070bc5980d23f9ee9fdae060fd8

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE   COMMAND     CREATED          STATUS        PORTS   NAMES
8e152e448781  env:v1  "/bin/bash" 45 seconds ago   Up 44 seconds         env-v2
2e1105498284  env:v1  "/bin/bash" 10 seconds ago   Up 9 seconds          env

demo@VirtualBox:~/Demo_Docker$ docker exec -u ricardo -ti 8e152e448781 bash

[ricardo@2e1105498284 /]$ env
// ...
prueba=1234
prueba1=4321
// ...
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Ver estadísticas de un contenedor

--------------------------------------------------------------------------

Para ver que consumo tiene un contenedor ejecutaremos `docker stats <container-name>`

```bash
demo@VirtualBox:~/Demo_Docker$ docker stats my-mongo

CONTAINER ID  NAME      CPU %  MEM USAGE / LIMIT     MEM %   NET I/O      BLOCK I/O       PIDS
6d320f9c3e30  my-mongo  0.29%  39.87MiB / 6.313GiB   0.62%   4.21kB / 0B  164kB / 1.11MB  26
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Administrar Usuarios

--------------------------------------------------------------------------

Aprenderemos como cambiar el rootname y modificar variables de entorno dentro del contenedor.

_[Dockerfile](./Dockerfile)_
```dockerfile
FROM centos
ENV prueba 1234
```

Y construimos la imagen mediante `docker build -t centos:prueba .`.

Ahora lanzamos el contenedor `docker run -d -ti --name prueba centos:prueba`.

Ingresamos en **prueba** mediante `docker excec -ti prueba bash`. 

Accedemos a ver la versión de centos de la imagen mediante `cat /etc/redhat-release` y el usuario del contenedor `whoami`.

Modificamos la imagen para crear un nuevo usuario:

_[Dockerfile](./Dockerfile)_
```diff
FROM centos
ENV prueba 1234
++ RUN useradd ricardo
++ USER ricardo
```

En el siguiente paso crearemos una nueva imagen como versión 2 mediante `docker build -t centos:prueba-v2 .`, y lanzamos el contenedor con la nueva imagen `docker run -d -ti --name prueba-v2 centos:prueba-v2`.

```bash
demo@VirtualBox:~/Demo_Docker$docker run -d -ti --name prueba-v2 centos:prueba-v2
d63f339bd250c71f7d260f4c8890e246a7bd0887a3d2428fe59daf758745ffd7

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE            COMMAND      CREATED   STATUS    PORTS                               NAMES
d63f339bd250 centos:prueba-v2 "/bin/bash"  58 sec... Up 57 ... prueba-v2
```

Si entramos dentro de la terminal del contenedor veremos que el usuario por defecto es ricardo y no root.

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec -ti prueba-v2 bash
[ricardo@d63f339bd250 /]$
```

Si usasemos el comando `docker exec -u root -ti prueba-v2 bash` indicaríamos que queremos que usuario de acceso sea **root**.

```bash
[ricardo@d63f339bd250 /]$ exit
exit

demo@VirtualBox:~/Demo_Docker$ docker exec -u root -ti prueba-v2 bash
[root@d63f339bd250 /]#
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Limitar los recursos de un contenedor

--------------------------------------------------------------------------

Creamos un contenedor de mongo mediante el comando `docker run -d --name my-mongo -p 8081:27017 mongo`.


```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name my-mongo -p 8081:27017 mongo
6a32e52277c49ad5b2346519e76d811294059cd9ffd420073bf1f1891bcea6e6

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE      COMMAND                 CREATED          STATUS        PORTS     NAMES
6d320f9c3e30  my-mongo  "docker-entrypoint.s…"   22 minutes ago   Up 22 minutes 0.0....   my-mongo
```

Para ver que consumo tiene un contenedor ejecutaremos `docker stats my-mongo`

```bash
demo@VirtualBox:~/Demo_Docker$ docker stats my-mongo

CONTAINER ID NAME     CPU % MEM USAGE/LIMIT   MEM % NET I/O   BLOCK I/O     PIDS
6d320f9c3e30 my-mongo 0.29% 39.87MiB/6.313GiB 0.62% 4.21kB/0B 164kB/1.11MB  26
```

Para limitar el consumo máximo de **RAM** (**6.313GiB**), ejecutaremos el comando `docker run -d -m "500mb" --name my-mongo-2 -p 8081:27017 mongo`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d -m "500mb" --name my-mongo-2 -p 8081:27017 mongo

demo@VirtualBox:~/Demo_Docker$ docker stats my-mongo-2

CONTAINER ID NAME       CPU % MEM USAGE/LIMIT MEM % NET I/O     BLOCK I/O       PIDS
6d320f9c3e30 my-mongo-2 0.29% 39.87MiB/500MiB 7.33% 4.21kB / 0B 164kB / 1.11MB  26
```

Para modificar la cantidad de CPU que usa el contenedor usaremos el siguiente comando. (`grep "model name" /proc/cpui nfo | wc -l` muestra la cantidad de CPU que dispone la máquina)

```bash
demo@VirtualBox:~/Demo_Docker$ grep "model name" /proc/cpui 
nfo | wc -l
2

demo@VirtualBox:~/Demo_Docker$ docker run -d -m "500mb" --name my-mongo-3 --cpuset-cpus 0-1 -p 8081:27017 mongo

demo@VirtualBox:~/Demo_Docker$ docker stats my-mongo-3

CONTAINER ID NAME       CPU % MEM USAGE/LIMIT MEM % NET I/O     BLOCK I/O       PIDS
6d320f9c3e30 my-mongo-3 0.29% 39.87MiB/500MiB 7.33% 4.21kB / 0B 164kB / 1.11MB  26
```

> Nota podemos ver todos los comandos relacionados mediante la línea `docker run --help | grep cpu`

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Copiar archivos de nuestra máquina al contenedor

--------------------------------------------------------------------------

Creamos una nueva imagen con **apache** `docker run -d --name apache -p 80:80 httpd`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name apache -p 80:80 httpd
0d6f5be0856c36a9c68f27b6f36ab5ef3621dbe83f24161a6e36ab0ae83c98ff
```

Miramos los contenedores que esten activos `docker ps`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE  COMMAND     CREATED  STATUS    PORTS    NAMES
0d6f5be0856c httpd  "httpd-..." 5 sec... Up 3 se.. 0.0....  apache
```

Y creamos un nuevo archivo con algo de contenido `echo ";)" > index.html`, y usamos el siguiente comando para visualizarlo `cat index.html`.

Y copiamos dicho archivo creado dentro del contenedor activo `docker cp index.html apache:/tmp`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker cp index.html apache:/tmp
```

Accedemos a la terminal del contenedor `docker exec -ti apache bash` y accedemos a la carpeta **/tmp/** (`cd /tmp/`) para visualizar el listado de archivos `ls -l`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec -ti apache bash
root@0d6f5be0856c:/usr/local/apache2# cd /tmp/
root@0d6f5be0856c:/tmp# ls
index.html
root@0d6f5be0856c:/tmp# cat index.html
;)
root@0d6f5be0856c:/tmp#
```

Para extraer un archivo usaremos el comando `docker cp apache:/var/log/dpkg.log .`

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Docker Commit

--------------------------------------------------------------------------

Aunque no es una práctica muy recomendable y se aconseja mejor usar volúmenes. Docker commit permite guardar contenedores que estén ya corriendo con sus pertinentes modificaciones y convertirlas en imágenes para posteriormente volver a montarlas.

_[Dockerfile](./Dockerfile)_
```dockerfile
FROM centos
VOLUME /opt/volume
```

Construimos nuestra image mediante `docker build -t centos-test .`

```bash
demo@VirtualBox:~/Demo_Docker$ docker build -t centos-test .
Sending build context to Docker daemon  2.048kB
// ...
Successfully tagged centos-test:latest
```

Creamos un contenedor a partir de esa imagen, `docker run -dti --name centos centos-test`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -dti --name centos centos-test
0323d5ef0fd386f6dd4a91aa5fe054e3f4d584641bd18dedab035fddb35f29e0
```

Accedo al contenedor y creo un nuevo archivo dentro del volumen `docker exec -ti centos bash`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec -ti centos bash
[root@0323d5ef0fd3 /]# cd /opt/
[root@0323d5ef0fd3 opt]# ll
total 4
drwxr-xr-x 2 root root 4096 Oct 27 15:23 volume
[root@0323d5ef0fd3 opt]# touch file1.txt
[root@0323d5ef0fd3 opt]# ll
total 4
-rw-r--r-- 1 root root    0 Oct 27 15:26 file1.txt
drwxr-xr-x 2 root root 4096 Oct 27 15:23 volume
[root@0323d5ef0fd3 opt]# exit
exit
```

Para realizar el commit usaremos la siguiente línea `docker commit <container-name> <new-image-name>`, `docker commit centos centos-commit`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker commit centos centos-commit
sha256:d9da554bbadaa150b946cf913ea19819549088e3484b232ac7c24ddc009c8b42
```

Si volvemos a montar dicha imagen y accedemos veremos que los cambios realizados han persistido.

> Nota: Puede ocurrir que durante este proceso el CMD de la imagen se pierda, por lo que para montarla será necesario incluirla dentro de la imagen `docker run -dti --name centos centos-commit /bin/bash`.

Si hubiesemos realizado esos cambios dentro del VOLUMEN de la imagen estos cambios no se comitearan ya que el VOLUMEN SIEMPRE es de solo lectura.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Como Sobreescribir un CMD

--------------------------------------------------------------------------

Para ello usaríamos una línea de comando tal que así `docker run -dti <image-name>:<image:tag> <new-CMD>`, ejemplo `docker run -dti --name centos centos echo hola mundo`

Para ver la resultante del proceso ejecutaremos `docker logs centos`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -dti --name centos centos echo hola mundo
3e1d2be23f06b5c5e2eee0bc915d7f50f19b8260703d8b795372508337dd8bad

demo@VirtualBox:~/Demo_Docker$ docker logs centos
hola mundo
```

Crearemos una nueva imagen con un plugin para centos de **python** `docker run -d -p 8080:8080 --name centos centos python -m SimpleHTTPServer 8080`

El plugin sería `python -m SimpleHTTPServer 8080`, este genera un micro server en el puerto **8080**.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d -p 8080:8080 --name centos centos python -m SimpleHTTPServer 8080
a0cdbd1b608fe09f3c700ca2efb077f7b8cadb200dd6203f8306fee2b79cb615
```

Ahora podremos acceder en el navegador a la dirección [http://localhost:8080/](http://localhost:8080/).

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.


--------------------------------------------------------------------------

### Contenedor que se autodestruye

--------------------------------------------------------------------------

Un usuo para este tipo de contenedores sería para chequear un archivo en concreto.

Para ello creamos nuestro contenedor `docker run -dti --name centos centos`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -dti --name centos centos
b7d4241f10bebc07ad6c222be4bdda2096bcc3768e4a357bbcb5fffa8488da9e
```

Listamos los conteneodres activos `docker ps`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE   COMMAND     CREATED  STATUS  PORTS  NAMES
b7d4241f10be centos  "/bin/bash" 4 sec..  Up 4 .. centos
```

Y accedemos dentro del contenedor `docker exec -ti centos bash`.

Visualizamos el contenido del archivo **/etc/profile**, `cat /etc/profile` para comprobar que está correcto y salimos del mismo `exit`.

```bash
$ docker exec -ti centos bash
[root@b7d4241f10be /]# cat /etc/profile
# /etc/profile

# System wide environment and startup programs, for login setup
// ...
[root@b7d4241f10be /]# exit
exit
```

Matamos el contenedor **centos**, `docker rm -fv centos`

```bash
demo@VirtualBox:~/Demo_Docker$ docker rm -fv centos
centos
```

Y volvemos a cargar el contenedor, pero esta vez una vez que salgamos del mismo se destruirá. Para ello, no lo usaremos en segundo plano (eliminando el `-d` del comando e incluyendo `--rm`, tal que así `docker run --rm -ti --name centos centos bash`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run --rm -ti --name centos centos bash
[root@671fa446c1fb /]# cat /etc/profile
# /etc/profile
// ...
[root@671fa446c1fb /]# exit
exit

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
```

El `--rm` utilizado instruye a **docker** para que destruya el contenedor nada más salir del mismo.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Cambiar el Document Root de Docker

--------------------------------------------------------------------------

Si hacemos un docker info `docker info | grep -i root` veremos nuestro directorio root actual.

```bash
demo@VirtualBox:~/Demo_Docker$ docker info | grep -i root
WARNING: No swap limit support
Docker Root Dir: /var/lib/docker
```

Cambiamos el usuario de linux a **root**, `sudo su`

```bash
demo@VirtualBox:~/Demo_Docker$ sudo su
[sudo] password for hector:
root@VirtualBox:~/Demo_Docker$ cd /var/lib/docker
root@VirtualBox:~/Demo_Docker$ ls
builder   containerd  image    overlay2  runtimes  tmp    volumes
buildkit  containers  network  plugins   swarm     trust
root@VirtualBox:~/Demo_Docker$
```

Cada vez que ejecutamos el comando `docker images` se muestra el contenido de imágenes alojadas en el **document root** de **docker**.

Para cambiar su ubicación deberemos cambiar el archivo de configuración de docker ubicado en **/lib/systemd/system/docker.service**

```diff
root@VirtualBox:~/Demo_Docker$ vi /lib/systemd/system/docker.service

[Unit]
Description=Docker Application Container Engine
// ...
# the default is not to use systemd for cgroups because the delegate issues still
# exists and systemd currently does not support the cgroup feature set required
# for containers run by docker
-- ExecStart=/usr/bin/dockerd -H fd://
++ ExecStart=/usr/bin/dockerd --data-rot /opt
//...

```

Y ejecutamos la relectura de **systemctl** mediante el comando `systemctl daemon-reload` y `systemctl restart docker` para restaurar docker.

Si escribieramos un `docker images`aparecerá vacío al estar la nueva ubicación sin imágenes disponibles por encontrarse en la anterior ubicación.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### QUIZ - Docker IMAGES

--------------------------------------------------------------------------

1. ¿Cuál es el puerto del contenedor? `docker run -d -p 8080:80 --name jenkins jenkins`

* 8080
* 80

2. El comando: `docker ps -l' retorna:

* El último contenedor creado
* El primer contenedor creado
* El contenedor creado con variables de entorno

3. ¿Cómo limitarías el uso de RAM de un contenedor creado con la imagen de mysql a 10M?

* `docker run -d --set-memory-ram "10mb" -e "MYSQL_ROOT_PASSWORD=1234567" mysql
* `docker run -d --set-mem-ram "10M" -e "MYSQL_ROOT_PASSWORD=1234567" mysql
* `docker run -d -m "10mb" -e "MYSQL_ROOT_PASSWORD=1234567" mysql
* `docker run -d --max-ram-allowed "10mb" -e "MYSQL_ROOT_PASSWORD=1234567" mysql   

4. Necesitas crear un contenedor de mongo, cuyo puerto interno es 27017, pero en tu host ya tienes ocupado ese puerto, así que, debes utilizar el puerto 27018. ¿Cómo lo harías?

* -p 27017
* -p 27017:27018
* -p 27018:27017
* No es posible

5. Ingresaste a un contenedor llamado drupal de esta manera: 
`docker exec -ti drupal bash`. 
Ahora quieres observar el contenido del archivo `/etc/shadow`, `[drupal@12dbs3bdsa] cat /etc/shadow`. 
Y recibes este error `bash: permission denied` 
¿Cómo lo solucionarías?

* Ingresando al contenedor con el usuario root. `docker exec -ti -u root bash`
* Ingresando al contenedor con el usuario root. `docker exec -ti -u drupal bash`
* Ingresando al contenedor con el usuario root. `docker exec -ti -u root drupal bash`
* Ingresando al contenedor con el usuario root. `docker exec -ti -u drupal drupal bash` 

6. Quieres copiar el archivo `/var/log/postgres/postgres.log`desde tu contenedor llamado db hacia `/opt` de tu máquina. ¿Cómo lo harías?

* `docker cp /var/log/postgres/postgres.log db:/opt`
* `docker cp postgres:/var/log/postgres/postgres.log`
* `docker cp /opt postgres:/var/log/postgres/postgres.log`
* `docker cp deb:/var/log/postgres/postgres.log /opt`
