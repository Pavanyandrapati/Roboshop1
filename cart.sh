script_path=${dirname $0}
source ${script_patch}/common.sh
echo -e "\e[31m>>>> Downloading content <<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m>>>> installing nodejs <<<<\e[0m"
yum install nodejs -y

echo -e "\e[31m>>>> adding user <<<<\e[0m"
useradd ${app_user}
rm -rf /app

echo -e "\e[31m>>>> create dir <<<<\e[0m"
mkdir /app

echo -e "\e[31m>>>> Downloading content <<<<\e[0m"
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip
cd /app

echo -e "\e[31m>>>> unzip content <<<<\e[0m"
unzip /tmp/cart.zip
cd /app
echo -e "\e[31m>>>> instal dependencies<<<<\e[0m"
npm install

echo -e "\e[31m>>>> Copying cart service <<<<\e[0m"
cp {script_patch}/cart.service /etc/systemd/system/cart.service

echo -e "\e[31m>>>> start cart service<<<<\e[0m"
systemctl daemon-reload
systemctl enable cart
systemctl start cart
systemctl restart cart