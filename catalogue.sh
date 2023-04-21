script_path=${dirname $0}
source ${${script_path}}/common.sh

echo -e "\e[31m>>>> Downloading content <<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m>>>> install nodejs <<<<\e[0m"
yum install nodejs -y

echo -e "\e[31m>>>> add user <<<<\e[0m"
useradd ${app_user}

ech -e "\e[31m>>>>>create dir <<<<\e[0m"
rm -rf /app
mkdir /app

echo -e "\e[31m>>>> Downloading content <<<<\e[0m"
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app

echo -e "\e[31m>>>> unzip content <<<<\e[0m"
unzip /tmp/catalogue.zip

echo -e "\e[31m>>>> instal dependencies <<<<\e[0m"
npm install

echo -e "\e[31m>>>> Copying catalogue service <<<<\e[0m"
cp {${script_path}}/catalogue.service /etc/systemd/system/catalogue.service

echo -e "\e[31m>>>> start cart service <<<<\e[0m"
systemctl daemon-reload
systemctl enable catalogue
systemctl start catalogue

echo -e "\e[31m>>>> Copying mongo repo <<<<\e[0m"
cp {${script_path}}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>> installing mongodb <<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m>>>> load schema <<<<\e[0m"
mongo --host mongodb-dev.pavan345.online </app/schema/catalogue.js