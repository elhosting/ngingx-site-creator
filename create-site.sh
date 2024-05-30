#!/bin/bash

# Solicitar el nombre del servidor
read -p "Ingrese el/los server_name (separados por espacio): " server_name

# Obtener solo el primer server_name
first_server_name=$(echo $server_name | awk '{print $1}')

# Solicitar la carpeta donde residirán los archivos (relativa a /var/www)
read -p "Ingrese la carpeta donde residirán los archivos (relativa a /var/www): " folder

# Definir la ruta completa de la carpeta
root_path="/var/www/$folder"

# Crear la carpeta si no existe
mkdir -p "$root_path"


# Definir el archivo de configuración de Nginx
config_file="/etc/nginx/sites-available/$first_server_name"

# Crear el archivo de configuración con el contenido necesario
cat <<EOL > "$config_file"
server {
    listen 80;
    server_name $server_name;

    root $root_path;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$args;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass unix:/var/run/php/php8.3-fpm.sock; # Ajusta esta línea según la versión de PHP que estés usando

        # Directivas de caché FastCGI específicas del dominio
        fastcgi_cache_bypass \$skip_cache;
        fastcgi_no_cache \$skip_cache;

        fastcgi_cache WORDPRESS;
        fastcgi_cache_valid 60m;
    }

    location ~ /\.ht {
        deny all;
    }

    # Configuración de FastCGI Cache
    set \$skip_cache 0;

    # No hacer cache para solicitudes de administración de WordPress y usuarios logueados
    if (\$request_method = POST) {
        set \$skip_cache 1;
    }
    if (\$query_string != "") {
        set \$skip_cache 1;
    }
    if (\$request_uri ~* "/wp-admin/|/xmlrpc.php|/wp-login.php|/wp-cron.php") {
        set \$skip_cache 1;
    }
    if (\$http_cookie ~* "comment_author|wordpress_[a-f0-9]+|wp-postpass|wordpress_no_cache|wordpress_logged_in") {
        set \$skip_cache 1;
    }

    location ~* \.(jpg|jpeg|png|gif|ico|css|js)$ {
        expires max;
        log_not_found off;
    }
}
EOL

# Crear un enlace simbólico en sites-enabled
ln -s "$config_file" "/etc/nginx/sites-enabled/"

# Probar la configuración de Nginx
if nginx -t; then
    # Reiniciar Nginx para aplicar los cambios
    if systemctl reload nginx; then
        echo "La configuración para $server_name ha sido creada y Nginx ha sido recargado exitosamente."
    else
        echo "La configuración para $server_name ha sido creada, pero la recarga de Nginx ha fallado."
    fi
else
    echo "Error en la configuración de Nginx. Por favor, revise los archivos de configuración."
fi
