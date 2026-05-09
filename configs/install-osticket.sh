#!/bin/bash
# osTicket Installation Script for Ubuntu Server 24.04
# TechOps Help Desk Lab
# IP: 10.1.10.20

echo "=== Step 1: Update System ==="
sudo apt update && sudo apt upgrade -y

echo "=== Step 2: Install Apache, MySQL, PHP ==="
sudo apt install apache2 mysql-server php php-mysqli php-json php-gd php-mbstring php-xml php-intl php-apcu unzip -y

echo "=== Step 3: Enable Apache Rewrite Module ==="
sudo a2enmod rewrite
sudo systemctl restart apache2

echo "=== Step 4: Secure MySQL ==="
echo "Run the following manually:"
echo "  sudo mysql_secure_installation"
echo "  - Validate password: N"
echo "  - Remove anonymous users: Y"
echo "  - Disallow root login remotely: Y"
echo "  - Remove test database: Y"
echo "  - Reload privilege tables: Y"

echo "=== Step 5: Create osTicket Database ==="
sudo mysql -u root <<EOF
CREATE DATABASE osticket;
CREATE USER 'osticket'@'localhost' IDENTIFIED BY 'Ticket@Lab2024!';
GRANT ALL PRIVILEGES ON osticket.* TO 'osticket'@'localhost';
FLUSH PRIVILEGES;
EOF

echo "=== Step 6: Download osTicket ==="
cd /tmp
wget https://github.com/osTicket/osTicket/releases/download/v1.18.3/osTicket-v1.18.3.zip

echo "=== Step 7: Extract and Move Files ==="
unzip osTicket-v1.18.3.zip -d osticket
sudo mv osticket/upload /var/www/html/osticket

echo "=== Step 8: Set Permissions ==="
sudo chown -R www-data:www-data /var/www/html/osticket
sudo chmod -R 755 /var/www/html/osticket

echo "=== Step 9: Copy Config File ==="
sudo cp /var/www/html/osticket/include/ost-sampleconfig.php /var/www/html/osticket/include/ost-config.php
sudo chmod 0666 /var/www/html/osticket/include/ost-config.php

echo "=== Step 10: Restart Apache ==="
sudo systemctl restart apache2

echo ""
echo "=== Installation Complete! ==="
echo "Open browser and go to: http://10.1.10.20/osticket/"
echo "Complete the web installer, then run post-install cleanup:"
echo "  sudo chmod 0644 /var/www/html/osticket/include/ost-config.php"
echo "  sudo rm -rf /var/www/html/osticket/setup"
