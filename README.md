# ngingx-site-creator

Instrucciones de uso:
Clonar este repositorio y copiar los scripts `install-service.sh` y `create-site.sh` en la carpeta `/usr/local/bin/` (en el caso de la distro Ubuntu). Modificar ambos archivos para que sean ejecutables usando el comando `chmod +x install-service.sh create-site.sh` dentro de la carpeta donde residen los scripts.

Permisos: Ejecutar estos script con privilegios de superusuario (root) o mediante sudo, ya que requiere acceso para modificar la configuración de Nginx.

### install-service.sh

Actualiza la instalacion base y luego instala:

+ nginx
+ php-fpm
+ todos los modulos necesarios para wordpress
+ zip tools
+ nfs kernel components
+ certbot

Además crea la carpeta de cache donde se alojarán los archivos de `fast_cgi` y modifica la configuracion de nginx para activar esta última.

Este script se corre por unica vez para inicializar el droplet.

### create-site.sh

Crea los archivos de configuracón para nginx de un nuevo site. También crea 
la carpeta donde residirán los archivos del site y permite opcionalmente 
compartir esta última carpeta como recuso de red para ser accedido desde otras
computadoras en la red.


Versión de PHP: Ajustar la línea `fastcgi_pass unix:/var/run/php/php8.3-fpm.sock;` según la versión de PHP-FPM que estés usando (por ejemplo, php7.4-fpm, php8.3-fpm, etc.).

