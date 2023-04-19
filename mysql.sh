dnf module disable mysql -y

cp /root/Roboshop1/mysql.repo /etc/yum.repos.d/mysql.repo

yum install mysql-community-server -y

systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass RoboShop@1
systemctl restart mysqld