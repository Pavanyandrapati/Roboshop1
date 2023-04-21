script_path=${dirname $0}
source ${script_path}/common.sh
echo -e "\e[31m>>>> disable mysql <<<<\e[0m"
dnf module disable mysql -y

echo -e "\e[31m>>>> Copying mysql repo <<<<\e[0m"
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo

echo -e "\e[31m>>>> install mysql <<<<\e[0m"
yum install mysql-community-server -y

echo -e "\e[31m>>>> start mysql service <<<<\e[0m"
systemctl enable mysqld
systemctl start mysqld

echo -e "\e[31m>>>> reset mysql password <<<<\e[0m"
mysql_secure_installation --set-root-pass RoboShop@1
systemctl restart mysqld