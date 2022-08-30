#!/bin/bash
yum update -y
yum -y remove httpd
yum -y remove httpd-tools
yum -y install wget
yum -y install unzip
yum install httpd -y
service httpd start
chkconfig httpd on

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

cd /var/www/html
wget https://github.com/kegby/test_wget_terraform/archive/refs/heads/main.zip -O site.zip
unzip -j site.zip
rm -f site.zip