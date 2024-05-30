#!/bin/bash

# Actualizar los paquetes del sistema
sudo apt update
sudo apt upgrade -y

# Instalar Nginx
sudo apt install nginx -y

# Instalar PHP y los módulos necesarios para WordPress
sudo apt install php-fpm php-mysql php-xml php-gd php-curl php-mbstring php-zip php-soap php-intl -y

# Instalar Certbot para la gestión de certificados SSL de Let's Encrypt
sudo apt install certbot python3-certbot-nginx -y

# Crear la carpeta de caché si no existe
cache_path="/var/cache/nginx"
if [ ! -d "$cache_path" ]; then
    mkdir -p "$cache_path"
    chown www-data:www-data "$cache_path"
    chmod 755 "$cache_path"
fi

# Añadir la directiva de fastcgi_cache_path en nginx.conf si no existe
if ! grep -q "fastcgi_cache_path /var/cache/nginx" /etc/nginx/nginx.conf; then
    sed -i '/http {/a \    fastcgi_cache_path /var/cache/nginx levels=1:2 keys_zone=WORDPRESS:100m inactive=60m;\n    fastcgi_cache_key "$scheme$request_method$host$request_uri";' /etc/nginx/nginx.conf
fi

# Probar la configuración de Nginx
if nginx -t; then
    # Reiniciar Nginx para aplicar los cambios
    if systemctl reload nginx; then
        # Confirmar instalación de Nginx y PHP-FPM
        nginx -v
        php-fpm -v
        echo "La instalación de Nginx, PHP-FPM, módulos de PHP para WordPress y Certbot ha sido completada."
    else
        echo "La instalación de Nginx, PHP-FPM, módulos de PHP para WordPress y Certbot ha sido completada, pero la recarga de Nginx ha fallado."
    fi
else
    echo "Error en la configuración de Nginx. Por favor, revise los archivos de configuración."
fi
    

