--------------------------------------------------------------------------

### Crear Contenedor con Jenkins

--------------------------------------------------------------------------

Usaremos el comando de descarga del repositorio de **Jenkins** `docker pull jenkins`.

Para correr la imagen de mongo descargada usaremos el comando siguiente `docker run -d --name <container-name> -p <machine-port>:<container-port> <image-name>:<image-tag>`

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d -p 7070:8080 --name jenkins-v1 jenkins
8bb02e7ebac540f6827d98849431d188cc45f0a7acf49c6ff2947cba0b569e9c

demo@VirtualBox:~/Demo_Docker$ docker ps
CONTAINER ID  IMAGE    COMMAND  CREATED  STATUS    PORTS    NAMES
8bb02e7ebac5  jenkins  "/bin…"  12 se... Up 11 s.. 8080/... jenkins-v1
```

Ahora podemos acceder en el navegador a [http://localhost:7070/](http://localhost:7070/) ver corriendo corriendo en ese puerto a **jenkins**.

Accedemos a la terminal del contenedor:

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec -ti jenkins-v1 bash

jenkins@ab123c3dd227:/$ cat /var/jenkins_home/secrets/initialAdminPassword
a4b7b1b497ae42d1a358e5f2344973ab
```

Y copiamos el password de administrador para acceder a **jenkins**. A continuación, nos preguntará que plugins queremos instalar.