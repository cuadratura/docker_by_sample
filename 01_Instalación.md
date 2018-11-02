--------------------------------------------------------------------------

### Instalación

--------------------------------------------------------------------------

#### Docker CE

Para Instalar Docker, recurriremos a la docuemntación oficial de **[Docker Doc](https://docs.docker.com/install/linux/docker-ce/ubuntu/#os-requirements)**.

Actualizamos el índice de **apt package**: 

```bash
sudo apt-get update
```

Instalamos los paquetes necesarios que posibilitan a **apt** usar el repositorio **https**: 

```bash
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
```

Añadimos la llave **GPG** de **Docker**.

```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```

Comprobamos la llave:

```bash
sudo apt-key fingerprint 0EBFCD88
```

Descargamos el repositorio.

```bash
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
```

Actualizamos nuevamente el índice de **apt package**: 

```bash
sudo apt-get update
```

E instalamos la última versión de Docker.

```bash
sudo apt-get install docker-ce
```

> **NOTA**: Docker podrá ser usado unicamnete por el usuario **root**, para habilitar su uso por nuestro usuario ejecutaremos el comando `sudo usermod -aG docker <user-name>` para posteriormente reiniciar la sesión y que surta efecto dicho cambio de permisos. Para ejecutar este comando necesitaremos conocer el password del usuario actual administrador.

> **NOTA**: Para conocer el `<user-name>` del usuario de la sesión simplemente habrá que preguntarlo en consola mediante el comando `whoami`.


```bash
demo@VirtualBox:~/Demo_Docker$ whoami
demo
demo@VirtualBox:~/Demo_Docker$ sudo usermod -aG docker hector
[sudo] password for demo:
```

#### Docker Compose

Para Instalar Docker Compose, recurriremos a la docuemntación oficial de **[Docker Doc](https://docs.docker.com/compose/install/)**.

> **NOTA**: Previamente se recomienda haber instalado **Docker CE**.

Descargamos la última versión de **Docker Compose**

```bash
sudo curl -L "https://github.com/docker/compose/releases/download/1.22.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```

Aplicamos permisos de ejecución sobre la instalación:

```bash
sudo chmod +x /usr/local/bin/docker-compose
```

Comprobamos la correcta instalación de **Docker Compose** conociendo la versión instalada.

```bash
docker-compose --version
```