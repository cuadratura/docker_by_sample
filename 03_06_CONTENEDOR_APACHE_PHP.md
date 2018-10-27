--------------------------------------------------------------------------

### Crear Contenedor con Apache con PHP Extra

--------------------------------------------------------------------------

- Un contenedor con la imagen de Apache + php creada en la anterior solicitud con:
  * 50Mb límites de RAM
  * Solo podrá acceder a la CPU 0
   * Debe tener dos variables de entorno:
      * ENV = dev
      * VIRTUALIZATION = docker
  * El webserver debe ser accesible vía puerto 5555 en el navegador

> Usaremos `docker run -dti -m "50mb" --cpuset-cpus 0 -e "ENV=dev" -e "VIRTUALIZATION=docker" --name apache-v1 -p 5555:80 httpd`

--------------------------------------------------------------------------

### Crear Contenedor con Apache con PHP Extra 2

--------------------------------------------------------------------------

- Un contenedor con la imagen de Apache + php creada en la anterior solicitud con:
  * 100Mb límites de RAM
  * Podrá acceder a la cpu 0 y 1
   * Debe tener tres variables de entorno:
      * ENV = stg
      * VIRTUALIZATION = docker
      * TYPE = container
  * El webserver debe ser accesible vía puerto 8181 en el navegador

Deberás comprobar su funcionamiento ingresando a tu localhost:5555 y localhost:8181

> Usaremos `docker run -dti -m "100mb" --cpuset-cpus 0-1 -e "ENV=stg" -e "VIRTUALIZATION=docker" -e "TYPE=container" --name apache-v2 -p 8181:80 httpd`
