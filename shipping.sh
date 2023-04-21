script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password"]; then
   echo input missing
   exit
fi
echo -e "\e[31m>>>> install maven <<<<\e[0m"
yum install maven -y

echo -e "\e[31m>>>> add user <<<<\e[0m"
useradd ${app_user}
rm -rf /app

echo -e "\e[31m>>>> create dir <<<<\e[0m"
mkdir /app

echo -e "\e[31m>>>> download app content <<<<\e[0m"
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app

echo -e "\e[31m>>>> unzip content <<<<\e[0m"
unzip /tmp/shipping.zip
cd /app

echo -e "\e[31m>>>> download maven dependencies <<<<\e[0m"
mvn clean package
mv target/shipping-1.0.jar shipping.jar

echo -e "\e[31m>>>> copying shipping service <<<<\e[0m"
cp $script_path/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[31m>>>> start shipping service <<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping

echo -e "\e[31m>>>> install mysql <<<<\e[0m"
yum install mysql -y

echo -e "\e[31m>>>> load schema <<<<\e[0m"
mysql -h mysql-dev.pavan345.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql