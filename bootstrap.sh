#!/bin/bash
set -e

apt-get update -y
apt-get upgrade -y
apt-get install -y apache2

systemctl stop apache2

sed -i 's/Listen 80/Listen /' /etc/apache2/ports.conf

mkdir -p 

cat > /index.html << 'HTMLEOF'
<!DOCTYPE html>
<html>
<head><title>Lab3 - Variant 09</title></head>
<body>
  <h1>Hello from GCP!</h1>
  <p>Server: </p>
  <p>Port: </p>
  <p>DocRoot: </p>
</body>
</html>
HTMLEOF

chown -R www-data:www-data 
chmod -R 755 

cat > /etc/apache2/sites-available/lab3.conf << 'APACHEEOF'
<VirtualHost *:>
    ServerName 
    DocumentRoot 

    <Directory >
        Options Indexes FollowSymLinks
        AllowOverride None
        Require all granted
    </Directory>

    ErrorLog /var/log/apache2/error.log
    CustomLog /var/log/apache2/access.log combined
</VirtualHost>
APACHEEOF

a2dissite 000-default.conf
a2ensite lab3.conf

echo "ServerName " >> /etc/apache2/apache2.conf

systemctl start apache2
systemctl enable apache2
