# QUIZ - Docker IMAGES

--------------------------------------------------------------------------

1. En la siguiente línea de un Dockerfile: `ENV animal gato`. ¿Cuál es el nombre de la variable?

* animal
* gato
* ENV

2.Considerando la siguiente imagen: `centos`. ¿Cuál es el tag que está usando?

* Ninguno
* new
* latest
* old

3.Observa estas líneas de un Dockerfile:

```dockerfile
USER foo
USER bar
RUN echo "Hola, mi nombre es $(whoami)" > /tmp/user.txt
```

¿Qué nombre estará dentro del archivo `/tmp/user.txt`?

* bar
* foo
* Ninguno

4.Existen dos archivos comprimidos en tu directorio actual:

```dockerfile
zip1 -> 10M
zip2 -> 15M
```

Considera el contenido de este **.dockerignore** : $ cat .dockerignore `zip2`
Si construyes una imagen en el directorio actual, ¿de cuánto será el contexto enviado a Docker?

* 25M
* 15M
* 10M
* 0M

5.Escoge cuál declaración es correcta.

* Pudeo generar un Dockerfile usando todos los argumentos, pero no es obligatorio.
* Puedo generar un Dockerfile usando todos los argumentos, es obligatrio.
* No puedo generar un Dockerfile con todos los argumentos
* Si genero un Dockerfile con todos los argumentos, a calidad de la imagen será baja.

6.Quieres instalar varios paquetes en una sola capa, ¿cómo lo harías?

* `RUN yum -y install && httpd && php`
* `RUN yum -y install httpd && php`
* `RUN yum -y install httpd php`