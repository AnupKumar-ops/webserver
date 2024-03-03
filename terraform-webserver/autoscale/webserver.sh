#! /bin/bash
dnf install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1> this is my apache web server whose hostname is $(hostname -f) </h1>" > /var/www/html/index.html
