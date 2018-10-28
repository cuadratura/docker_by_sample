
--------------------------------------------------------------------------

### Redes en Docker

--------------------------------------------------------------------------

Si ejecutamos en consola el comando `ip a | grep docker` podremos ver la red por defecto de **Docker**.

```bash
demo@VirtualBox:~/Demo_Docker$ ip a | grep docker
3: docker0: <NO-CARRIER,BROADCAST,MULTICAST,UP> mtu 1500 qdisc noqueue state DOWN group default
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
```

La red por defecto de **docker** es **docker0**, la cual asigna un rango de subnets.

Si creamos un contenedor nuevo, por ejemplo `docker run -d --name centos centos`, y lo inspeccionamos `docker inspect centos`veremos que su **IpAddress** estará dentro de ese subrango.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name centos centos
e231f4ab68bccbbcbc3e16b7853f465c2141bd636f3d66303bc0c71fe33365a5

demo@VirtualBox:~/Demo_Docker$ docker inspect centos
[
    {
        "Id": "e231f4ab68bccbbcbc3e16b7853f465c2141bd636f3d66303bc0c71fe33365a5",
// ...
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.2",
// ...
                }
            }
        }
    }
]
```

Esta Ip, se asigna con base a la existente en la entidad gráfica, `"Gateway"` es la ip por defecto, mientras que `"IPAddress"` sería la subip de nuestro contenedor.

Para ver el listado de redes de docker existentes podemos usar el comando `docker network ls`, las cuales podemos filtrarlas usando `docker network ls | grep bridge`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network ls
NETWORK ID          NAME                DRIVER              SCOPE
21bae51a7573        bridge              bridge              local
// ...
```

Ahora ejecutaremos un `docker network inspect bridge` lo que nos mostrará el **Gateway** y la **subnet** utilizada.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network inspect bridge
[
    {
// ...
        "IPAM": {
// ...
            "Config": [
                {
                    "Subnet": "172.17.0.0/16",
                    "Gateway": "172.17.0.1"
                }
            ]
        },
```

Generamos un segundo contenedor a partir de la imagen inicial de **centos**.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name centos2 centos
056305ac9bc114787939d66b8de0694b90a85e6cc473ac9f0acb63c6b81d659c

demo@VirtualBox:~/Demo_Docker$ docker inspect centos2
[
    {
        "Id": "056305ac9bc114787939d66b8de0694b90a85e6cc473ac9f0acb63c6b81d659c",
// ...
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
// ...
                }
            }
        }
    }
]
```

Veremos que la **IpAddress** es distinta con respecto al contenedor anterior (**172.17.0.2** vs **172.17.0.3**). 

Si hacemos un **ping** entre ambos, `docker exec centos2 bash -c "ping 172.17.0.2"` contenedores veremos que existe una respuesta.

```bash 
demo@VirtualBox:~/Demo_Docker$ docker exec centos2 bash -c "ping 172.17.0.2"
PING ....
```

> La **Redes en Docker** nos permitirán conectar contenedores unos con otros de una forma sencilla.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Crear una red definida por el usuario

--------------------------------------------------------------------------

Para crear una red con Docker usaremos el comando `docker network create <network-name>`, por ejemplo `docker network create tests`.

Podremos hacer un **grep** con la red que acabamos de crear usando `docker network ls | grep tests`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network create tests
efe7a3baa2dd726d9cdc6fa67e5b8e9c94486880e087004fc7024f85f892bc1e
```

> Nota: Usando `docker network --help` podremos ver la ayuda de este componente.

Así, podremos crear un red con una subnet con el siguiente comando `docker network create -d bridge --subnet 172.124.10.0/24 --gateway 172.124.10.1 docker-test-network`.

> La **subnet** y **gateway** están relacionadas de forma que será igual **gateway** a **subnet** simplificada y empezando por 1.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network ls | grep tests
efe7a3baa2dd        tests               bridge              local
demo@VirtualBox:~/Demo_Docker$ docker network create -d bridge --subnet 172.124.10.0/24 --gateway 172.124.10.1 docker-test-network
9e0f1a3bf2ed0308c1d11d57658443e063bbb49df5fdc423ef28367f9e138641
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Inspeccionar una red

--------------------------------------------------------------------------

Creamos un conteendor nuevo `docker run -d --name docker-test-network centos`, con el que trabajar.

Para inspeccionar una red usaremos el comando `docker network inspect docker-test-network`, en este caso usaríamos. Podremos ver que este caso tanto la subnet como gateway corresponden a las indicadas.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name docker-test-network centos
056305ac9bc114787939d66b8de0694b90a85e6cc473ac9f0acb63c6b81d659c

demo@VirtualBox:~/Demo_Docker$ docker inspect docker-test-network
[
    {
        "Id": "056305ac9bc114787939d66b8de0694b90a85e6cc473ac9f0acb63c6b81d659c",
// ...
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
// ...
                }
            }
        }
    }
]
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.


--------------------------------------------------------------------------

### Agregar contenedores a una Red distinta de la de por Defecto

--------------------------------------------------------------------------

Creamos un contenedor nuevo `docker run -d --name docker-test-network centos`, con el que trabajar.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --name docker-test-network centos
056305ac9bc114787939d66b8de0694b90a85e6cc473ac9f0acb63c6b81d659c

demo@VirtualBox:~/Demo_Docker$ docker inspect docker-test-network
[
    {
        "Id": "056305ac9bc114787939d66b8de0694b90a85e6cc473ac9f0acb63c6b81d659c",
// ...
                    "Gateway": "172.17.0.1",
                    "IPAddress": "172.17.0.3",
// ...
                }
            }
        }
    }
]
```

Vemos que su coniguración sería la estándar.

Creamos una red con Docker usado el comando `docker network create <network-name>`, por ejemplo `docker network create tests`, o listamos las existentes para ver cual nos interesaría filtrándolas `docker network ls | grep bridge`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network ls | grep bridge
6bef8cda715c        bridge                bridge              local
9e0f1a3bf2ed        docker-test-network   bridge              local
```

Ahora asignamos la red a la que queremos conectar el contenedor `docker run --network docker-test-network -d --name test -ti centos`.

```ash
demo@VirtualBox:~/Demo_Docker$ docker run --network docker-test-network -d --name test -ti centos
517fe6055924032d289780658668d6c530cb9860c2006e9449593d5768ca8acb
```

Si inspeccionamos el contenedor veremos que habrá heredado las redes asociadas: 

```bash
demo@VirtualBox:~/Demo_Docker$ docker inspect test
[
    {
        "Id": "517fe6055924032d289780658668d6c530cb9860c2006e9449593d5768ca8acb",
// ...
                "docker-test-network": {
// ...
                    "Gateway": "172.124.10.1",
                    "IPAddress": "172.124.10.2",
// ...
]
```

Para comprobarlo inspeccionamos la configuración de la red conectada `docker network inspect docker-test-network`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network inspect docker-test-network
[
    {
        "Id": "9e0f1a3bf2ed0308c1d11d57658443e063bbb49df5fdc423ef28367f9e138641",
//..
            "Config": [
                {
                    "Subnet": "172.124.10.0/24",
                    "Gateway": "172.124.10.1"
                }
//..
]
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.

--------------------------------------------------------------------------

### Conectar Contenedores en la Misma Red Creada

--------------------------------------------------------------------------

Creamos un primer contenedor con la red creada anteriormente **docker-test-network** `docker run -d --network docker-test-network --name test1 -ti centos`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --network docker-test-network --name test1 -ti centos
620173a6769926077f8081d080562e4b6890804887a070ca3deb3841a065b889
```

Y lo inspeccionamos `docker inspect test1`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker inspect test1
[
    {
        "Id": "620173a6769926077f8081d080562e4b6890804887a070ca3deb3841a065b889",
// ...
            "Networks": {
                "docker-test-network": {
// ...
                    "Gateway": "172.124.10.1",
                    "IPAddress": "172.124.10.3",
// ...
                }
// ...
```

Hacemos lo mismo con un segundo contenedor `docker run -d --network docker-test-network --name test2 -ti centos`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --network docker-test-network --name test2 -ti centos
27e2fac18c9a97433ac794c49bcf7c5c339891030742e79948a3c638e2bfadb3
```

Y lo inspeccionamos `docker inspect test2`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker inspect test2
[
    {
        "Id": "620173a6769926077f8081d080562e4b6890804887a070ca3deb3841a065b889",
// ...
            "Networks": {
                "docker-test-network": {
// ...
                    "Gateway": "172.124.10.1",
                    "IPAddress": "172.124.10.4",
// ...
                }
// ...
```

Ahora haremos un ping desde el contenedor 1 al 2 `docker exec test1 bash -c "ping 172.124.10.4"`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec test1 bash -c "ping 172.124.10.4"
PING 172.124.10.4 (172.124.10.4) 56(84) bytes of data.
64 bytes from 172.124.10.4: icmp_seq=1 ttl=64 time=0.085 ms
64 bytes from 172.124.10.4: icmp_seq=2 ttl=64 time=0.066 ms
// ...
```

Y viceversa, del 2 hacia el 1 `docker exec test2 bash -c "ping 172.124.10.3"`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec test2 bash -c "ping 172.124.10.3"
PING 172.124.10.3 (172.124.10.3) 56(84) bytes of data.
64 bytes from 172.124.10.3: icmp_seq=1 ttl=64 time=0.091 ms
64 bytes from 172.124.10.3: icmp_seq=2 ttl=64 time=0.056 ms
// ...
```

Vemos que ambos responden al comunicarse entre ambos. 

> Docker permite además de hacer **ping** entre contenedores por sus ip de conexión, mediante el nombre del contenedor `docker exec test2 bash -c "ping test1"`. **Esto solo funciona cuando hemos sido nosotros quienes creamos la red y es una red compartida**.

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec test2 bash -c "ping test1"
PING test1 (172.124.10.3) 56(84) bytes of data.
64 bytes from test1.docker-test-network (172.124.10.3): icmp_seq=1 ttl=64 time=0.085 ms
64 bytes from test1.docker-test-network (172.124.10.3): icmp_seq=2 ttl=64 time=0.065 ms
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.


--------------------------------------------------------------------------

### Conectar Contenedores en Distintas Redes Creadas

--------------------------------------------------------------------------

Listamos las redes existentes `docker network ls | grep bridge`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network ls | grep bridge
6bef8cda715c        bridge                bridge              local
9e0f1a3bf2ed        docker-test-network   bridge              local
```

Y creamos una nueva `docker network create -d bridge --subnet 192.124.10.0/24 --gateway 192.124.10.1 docker-test-network-2`

```bash
demo@VirtualBox:~/Demo_Docker$ docker network create -d bridge --subnet 192.124.10.0/24 --gateway 192.124.10.1 docker-test-network-2
ba225585835fc1e2340e7ff99aacbd214f1b30cb19f6ea3a53052974e66360c3

demo@VirtualBox:~/Demo_Docker$ docker network ls | grep bridge6bef8cda715c        bridge                  bridge              local
9e0f1a3bf2ed        docker-test-network     bridge              local
ba225585835f        docker-test-network-2   bridge              local
```

Creamos dos contenedores conectados a redes distintas `docker run -d --network docker-test-network --name test1 -ti centos` y `docker run -d --network docker-test-network-2 --name test2 -ti centos`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker run -d --network docker-test-network --name test1 -ti centos
07011998ca485bf50439e71de9df93849f0ff22029a3d23aac57f017ee35db11

demo@VirtualBox:~/Demo_Docker$ docker run -d --network docker-test-network-2 --name test2 -ti centos
f4937e50bdbd4dc1c264c00789e2104bddb7f58c35b7bf896cef62e129e1ed17
```

Así, aunque ambas redes sean distintas podemos conectar un contenedor existente a una red distinta mediante `docker network connect <network-to-connect> <container-name-to-connect>`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network connect docker-test-network test2
demo@VirtualBox:~/Demo_Docker$ docker inspect test2
[
    {
        "Id": "f4937e50bdbd4dc1c264c00789e2104bddb7f58c35b7bf896cef62e129e1ed17",
// ...
            "Networks": {
                "docker-test-network": {
// ...
                    "Gateway": "172.124.10.1",
                    "IPAddress": "172.124.10.3",
// ...
                },
                "docker-test-network-2": {
// ...
                    "Gateway": "192.124.10.1",
                    "IPAddress": "192.124.10.2",
// ...
        }
```

Veremos que se ha incluido la red indicada dentro de la configuración del conteendor.

Finalmente si hacemos un PING entre ambos contenedores estos se contestarán.

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec test2 bash -c "ping test1"
$ docker exec test2 bash -c "ping test1"
PING test1 (172.124.10.2) 56(84) bytes of data.
64 bytes from test1.docker-test-network (172.124.10.2): icmp_seq=1 ttl=64 time=0.107 ms
64 bytes from test1.docker-test-network (172.124.10.2): icmp_seq=2 ttl=64 time=0.069 ms
64 bytes from test1.docker-test-network (172.124.10.2): icmp_seq=3 ttl=64 time=0.083 ms
```

**¿Cómo desconectaríamos la red incluida?** Para ello ejecutaríamos `docker network disconnect docker-test-network test2`.

Una vez desconectados, no funcionarían los **PINGs** entre contenedores.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.


--------------------------------------------------------------------------

### Eliminar Redes

--------------------------------------------------------------------------

Para eliminar una red usaremos el comando `docker network rm <network-name>`.

> Nota para eliminar redes es necesario que no exista ningun contenedor conectado con esa red.

Para eliminar todas las redes no usadas de golpe usaremos `docker network prune`.

--------------------------------------------------------------------------

### Asignar Ip a un contenedor

--------------------------------------------------------------------------

Primeramente crearemos una nueva red llamada **my-net** mediante el comando `docker network create --subnet 172.128.10.0/24 --gateway 172.128.10.1 -d bridge my-net`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network create --subnet 172.128.10.0/24 --gateway 172.128.10.1 -d bridge my-net
8b880a0f8641d8e19c634b12db202fd95761e9a468809e8dba97048e09206cce

demo@VirtualBox:~/Demo_Docker$ docker network ls
NETWORK ID          NAME                    DRIVER              SCOPE
6bef8cda715c        bridge                  bridge              local
8b880a0f8641        my-net                  bridge              local
```

Inspeccionamos la red creada `docker network inspect my-net`.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network inspect my-net
[
    {
// ...
        "Id": "8b880a0f8641d8e19c634b12db202fd95761e9a468809e8dba97048e09206cce",
// ...
            "Config": [
                {
                    "Subnet": "172.128.10.0/24",
                    "Gateway": "172.128.10.1"
// ...
    }
]
```

Y ahora creamos un nuevo contenedor llamado **nginx-v1** a partir de **centos** cuya red será **my-net** con una **ip** `172.128.10.50` mediante el comando `docker run --network my-net --ip 172.128.10.50 -d --name nginx-v1 -ti centos`.

```bash
demo@VirtualBox:~/Demo_Docker$ $ docker run --network my-net --ip 172.128.10.50 -d --name nginx-v1 -ti centos
d31ff4aebbc1bcd33634071a4fa54e95bd42d40c3a1d4d628df24ebda1b78511
```

Si inspeccionasemos el contenedor veríamos que tiene la ip asignada.

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.


--------------------------------------------------------------------------

### Red Host

--------------------------------------------------------------------------

Para crear un contenedor en la red del **Host**. **Host** es una red que tiene por defecto **docker** y está asociada a la red por la que nos conectamos.

```bash
demo@VirtualBox:~/Demo_Docker$ $ docker network ls
NETWORK ID          NAME                    DRIVER              SCOPE6bef8cda715c        bridge                  bridge              local
d4bdc9cf07a2        host                    host                local8b880a0f8641        
```

Para crear un contenedor que se conecte a esa red usaremos `docker run --network host -d --name test2 -ti centos`.

```bash
demo@VirtualBox:~/Demo_Docker$ $ docker run --network host -d --name test2 -ti centos
e238ed9fb10d349a1b219e300f9edaaaed407a99e06f4b44bc4009ffc95cfc92
```

Accedemos a la terminal de contenedor `docker exec -ti test2 bash`, e instalamos el paquete **net-tools** para ver la configuración de **host** en ambas máquinas (real y contenedor de Docker)

```bash
demo@VirtualBox:~/Demo_Docker$ docker exec -ti test2 bash
[root@demo-VirtualBox /]# yum -y install net-tools
Loaded plugins: fastestmirror, ovl
// ...
[root@hector-VirtualBox /]# ifconfig
br-8b880a0f8641: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.128.10.1  netmask 255.255.255.0  broadcast 172.128.10.255
// ...
[root@hector-VirtualBox /]# exit
exit
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.


--------------------------------------------------------------------------

### Red None

--------------------------------------------------------------------------

La red **None** implica que todos los conteneodres que la usen no dispondrán de una red.

```bash
demo@VirtualBox:~/Demo_Docker$ docker network ls | grep none
1afee862a897        none                    null                local
```

Si creamos un nuevo contenedor `docker run --network none --name test -d -ti centos`, y lo inspeccionamos `docker inspect test`.
```bash
demo@VirtualBox:~/Demo_Docker$ docker run --network none --name test -d -ti centos
20b6b94fc6431042f11ec4d00c12079f5987aa4070806ad28a3349ff82421478

demo@VirtualBox:~/Demo_Docker$ docker inspect test
[
    {
        "Id": "20b6b94fc6431042f11ec4d00c12079f5987aa4070806ad28a3349ff82421478",
// ...
            "Networks": {
                "none": {
// ...
                    "Gateway": "",
                    "IPAddress": "",
// ...
```

> Para borrar todos los contenedores usaremos el comando `docker rm -fv $(docker ps -aq)`.


--------------------------------------------------------------------------

### QUIZ - Docker NETWORK

--------------------------------------------------------------------------
1. ¿Cuál es el nombre del driver por defecto para crear redes?
    * None
    * Host
    * Bridge

2. Si quieres que un contenedor herede absolutamente todas tus configuraciones de re, incluyendo hostname, ip e interfaces, ¿Cómo lo harías?
    * No es posible
    * Agregándolo a la red de Host
    * Agregándolo a la red None

3. Debes eliminar una red que previamnete creaste, pero te lanza el error que dice que aún tienes puntos activos. ¿Cómo lo solucionarías?
    * Reiniciando la máquina
    * Eliminando las imágenes que estén dentro de esa red
    * Eliminando los contenedores que estén dentro de esa red
    * No es posible eliminar redes que hayamos creado

4. Creaste un contenedor de Apache llamado "apache" y uno de msql llamado "mysql" en la red por defecto de Docker (bridge). ¿QQué sucede si intentas hacer ping al nombre "mysql" desde el contenedor "apache"?
    * Va a responder, porque en la red por defecto los contenedores se pueden ver por nombres
    * va a responder, porque en la red por defecto los contenedores asimilan Ips públicas
    * No va a responder, porque en la red por defecto los contenedores no tienen Ips
    * No va a responder, porque en la red por defecto los contenedores no se pueden ver por sus nombres.

5. Quieres crear un contenedor que sólo será para crear un par de archivos, por lo que no quieres unirlo a ninguna red. ¿Cómo lo harías?
    * `docker run -d -ti --network any centos` 
    * `docker run -d -ti --network --no-ip-assigned centos`
    * `docker run -d -ti --network none centos`
    * `docker run -d -ti --network empty centos`            