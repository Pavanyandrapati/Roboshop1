script_path=${dirname $0}
source ${script_patch}/common.sh
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
cp {script_patch}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[31m>>>> start shipping service <<<<\e[0m"
systemctl daemon-reload
systemctl enable shipping
systemctl start shipping

echo -e "\e[31m>>>> install mysql <<<<\e[0m"
yum install mysql -y

echo -e "\e[31m>>>> load schema <<<<\e[0m"
mysql -h mysql-dev.pavan345.online -uroot -pRoboShop@1 < /app/schema/shipping.sql