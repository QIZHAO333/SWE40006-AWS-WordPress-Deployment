#!/bin/bash

# Start the services included in the WordPress AMI.
systemctl enable httpd
systemctl enable php-fpm
systemctl restart php-fpm
systemctl restart httpd

# Create the Application Load Balancer health-check page.
printf 'healthy\n' > /var/www/html/health.html
chown apache:apache /var/www/html/health.html
chmod 644 /var/www/html/health.html
