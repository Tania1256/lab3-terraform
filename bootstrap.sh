#!/bin/bash
set -e

apt-get update -y
apt-get upgrade -y
apt-get install -y apache2

systemctl stop apache2

sed -i "s/Listen 80/Listen ${web_port}/" /etc/apache2/ports.conf

mkdir -p ${doc_root}

cat > ${doc_root}/index.html << HTMLEOF
<!DOCTYPE html>
<html>
<head><title>Lab3 - Variant 09</title></head>
<body>
  <h1>Hello from GCP!</h1>
  <p>Server: ${server_name}</p>
  <p>Port: ${web_port}</p>
  <p>DocRoot: ${doc_root}</p>
</body>
</html>
HTMLEOF

chown -R www-data:www-data ${doc_root}
chmod -R 755 ${doc_root}

cat > /etc/apache2/sites-available/lab3.conf << APACHEEOF
<VirtualHost *:${web_port}>
    ServerName ${server_name}
    DocumentRoot ${doc_root}

    <Directory ${doc_root}>
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

echo "ServerName ${server_name}" >> /etc/apache2/apache2.conf

systemctl start apache2
systemctl enable apache2