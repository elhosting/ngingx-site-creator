# ngingx-site-creator
Scripts de creacion de sites en nginx

Colocar el script `create-site.sh` en la carpeta `/usr/local/bin/` (en el caso de la distro Ubuntu).

Versión de PHP: Ajustar la línea fastcgi_pass unix:/var/run/php/php8.3-fpm.sock; según la versión de PHP-FPM que estés usando (por ejemplo, php7.4-fpm, php8.3-fpm, etc.).

Permisos: Ejecutar este script con privilegios de superusuario (root) o mediante sudo, ya que requiere acceso para modificar la configuración de Nginx.
