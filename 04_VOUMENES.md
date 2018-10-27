> Los volúmenes permiten almacenar data persistente del contenedor, en caso de que el contenedor se elimine. Es muy útil para contendores de bases de datos.

Existen tres tipos de volúmenes:
* **Host**, son volúmenos que se almacenan dentro de nuestro **dockerhost** y se almacenan en una carpeta de nuestro docker file que nosotros definimos previamente.
* **Anonymus**, no se definen en una carpeta, pero docker los guarda en una capreta random
* **Named Volumnes**, no son carpetas administradas por docker, peroa  diferencias de **Anonymus** disponen de un nombre**