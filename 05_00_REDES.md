
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

Para ver el listado de redes de docker existente podemos usar el comando `docker network ls`, las cuales podemos filtrarlas usando `docker network ls | grep bridge`.

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

Si ahcemos un ping entre ambos, `docker exec centos2 bash -c "ping 172.17.0.2"` contenedores veremos que existe una respuesta.

```bash 
demo@VirtualBox:~/Demo_Docker$ docker exec centos2 bash -c "ping 172.17.0.2"
PING ....
```

Este sistema nos permitirá conectar contenedores unos con otros de una forma sencilla.


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

--------------------------------------------------------------------------

### Inspeccionar una red

--------------------------------------------------------------------------

Para inspeccionar una red usaremos el comando `docker network inspect docker-test-network`, en este caso usaríamos. Podremos ver que este caso tanto la subnet como gateway corresponden a las indicadas.


