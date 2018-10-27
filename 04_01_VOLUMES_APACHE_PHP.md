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
  * En /opt/source1 (Debes crear el directorio en tu máquina local) debe persistir el código que se incluya en el webserver. En este caso, para pruebas, utilizarás un phpinfo que debe sobrevivir a la eliminación del contenedor.

Crearemos una carpeta dónde se encuentre el proyecto llamada **/opt/source1** con permisos de escritura (`mkdir /opt/source1` o `sudo mkdir /opt/source1`)

> Usaremos `docker run -dti -m "50mb" --cpuset-cpus 0 -e "ENV=dev" -e "VIRTUALIZATION=docker" --name apache-v1 -p 5555:80 -v /opt/source1/:/public-html httpd`


