# Que es Docker

---------------------------------------------

Es muy probable que últimamente de una u otra forma hayas escuchado hablar de Docker en algún contexto: en una conferencia, a un desarrollador de tu empresa, a alguien de sistemas, cuando se habla de entornos, despliegues…

Y es que esta tecnología está bastante relacionada con el área de sistemas, con los entornos en los que se ejecutan las aplicaciones software.

[Volver al inicio](volver-al-inicio)




## QUE ES DOCKER

---------------------------------------------

**La idea detrás de Docker es crear contenedores ligeros y portables para las aplicaciones software que puedan ejecutarse en cualquier máquina con Docker instalado, independientemente del sistema operativo que la máquina tenga por debajo, facilitando así también los despliegues.**

[Volver al inicio](volver-al-inicio)




## QUE ES UN CONTENEDOR

---------------------------------------------

Este concepto ya es antiguo, y viene de Linux, pero por hacerte un símil con el mundo real, imagina en tu cabeza un contenedor de esos que suelen llevar los barcos de mercancías, que contiene distintos productos.

**Es algo auto contenido en sí, que se puede llevar de un lado a otro de forma independiente, es portable.**

Ahora, volviendo al software, para que podamos acceder como usuarios normales a una aplicación, dicha aplicación software necesita estar ejecutándose en una máquina, en un ordenador. Pero además, dependiendo del tipo de aplicación, dicho ordenador también necesita tener instaladas una serie de cosas para que la aplicación se ejecute correctamente: cierta versión de Java instalado, un servidor de aplicaciones (p.e tomcat, que es el software que realmente estará ejecutando mi aplicación y haciendo que pueda interactuar con ella).

Docker, me permite meter en un contenedor (“una caja”, algo auto contenido, cerrado) todas aquellas cosas que mi aplicación necesita para ser ejecutada (java, Maven, tomcat…) y la propia aplicación. Así yo me puedo llevar ese contenedor a cualquier máquina que tenga instalado Docker y ejecutar la aplicación sin tener que hacer nada más, ni preocuparme de qué versiones de software tiene instalada esa máquina, de si tiene los elementos necesarios para que funcione mi aplicación , de si son compatibles…

Yo ejecutaré mi aplicación software desde el contenedor de Docker, y dentro de él estarán todas las librerías y cosas que necesita dicha aplicación para funcionar correctamente.

[Volver al inicio](volver-al-inicio)




## QUE BENEFICIOS TIENE ESTO

---------------------------------------------

Docker es una herramienta diseñada para beneficiar tanto a desarrolladores, testers, como administradores de sistemas, en relación a las máquinas, a los entornos en sí donde se ejecutan las aplicaciones software, los procesos de despliegue, etc.

En el caso de los desarrolladores, el uso de Docker hace que puedan centrarse en desarrollar su código sin preocuparse de si dicho código funcionará en la máquina en la que se ejecutará.

Por ejemplo, sin utilizar Docker un posible escenario podría ser el siguiente (hay otras formas de solucionar este escenario, pero por poner un ejemplo claro):

* Pepe tiene en su ordenador instalado Java 8, y está programando una funcionalidad específica de la aplicación con algo que solo está disponible en esa versión de Java.

* José tiene instalado en su máquina Java 7, porque está en otro proyecto trabajando sobre otro código, pero Pepe quiere que José ejecute el código de su aplicación en su máquina. O José se instala Java 8, o la aplicación en su máquina fallará.

Este escenario desaparece con Docker. Para ejecutar la aplicación, Pepe se crea un contenedor de Docker con la aplicación, la versión 8 de Java y el resto de recursos necesarios, y se lo pasa a José.

José, teniendo Docker instalado en su ordenador, puede ejecutar la aplicación a través del contenedor, sin tener que instalar nada más.

[Volver al inicio](volver-al-inicio)




## ES RECOMENDADO SU USO EN TESTING

---------------------------------------------

Por eso Docker también es **muy bueno para el testing**, para tener entornos de pruebas. Por un lado, es muy sencillo crear y borrar un contenedor, además de que son muy ligeros, por lo que podemos ejecutar varios contenedores en una misma máquina (donde dicho contenedor tendría el entorno de nuestra aplicación: base de datos, servidor, librerías…). Por otro, un mismo contenedor funcionará en cualquier máquina Linux: un portátil, el ordenador de tu casa, máquinas alojadas en Amazon, tu propio servidor…

Esto además beneficia a la parte de sistemas, ya como los contenedores son más ligeros que las máquinas virtuales, se reduce el número de máquinas necesarias para tener un entorno.

Y lo que es mejor, Docker es **open source**.


[Volver al inicio](volver-al-inicio)




## QUE DIFERENCIA HAY CON UNA MAQUINA VIRTUAL

---------------------------------------------

Realmente el **concepto es algo similar**, pero un contenedor no es lo mismo que una máquina virtual. 

* Un contenedor es **más ligero**, ya que mientras que a una máquina virtual necesitas instalarle un sistema operativo para funcionar, un contenedor de Docker funciona utilizando el sistema operativo que tiene la máquina en la que se ejecuta el contenedor.

Digamos que el contenedor de Docker toma los recursos más básicos, que no cambian de un ordenador a otro del sistema operativo de la máquina en la que se ejecuta. Y los aspectos más específicos del sistema que pueden dar más problemas a la hora de llevar el software de un lado a otro, se meten en el interior del contenedor.