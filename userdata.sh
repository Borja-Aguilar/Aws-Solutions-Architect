#!/bin/bash
# Actualizar paquetes e instalar dependencias
apt-get update -y
apt-get install -y nginx

# Configurar una página web sencilla
echo "<h1>Desplegado mediante Terraform y User Data</h1>" > /var/www/html/index.html

# Asegurar que el servicio esté activo y habilitado al reiniciar
systemctl start nginx
systemctl enable nginx
