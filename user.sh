script_path=${dirname $0}
source ${script_path}/common.sh

echo -e "\e[31m>>>> Downloading content <<<<\e[0m"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

echo -e "\e[31m>>>> installing nodejs <<<<\e[0m"
yum install nodejs -y

echo -e "\e[31m>>>> adding user <<<<\e[0m"
useradd ${app_user}
rm -rf /app
echo -e "\e[31m>>>> adding user <<<<\e[0m"
mkdir /app

echo -e "\e[31m>>>> Downloading content <<<<\e[0m"
curl -o /tmp/user.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app

echo -e "\e[31m>>>> unzip content <<<<\e[0m"
unzip /tmp/user.zip
cd /app

echo -e "\e[31m>>>> instal dependencies<<<<\e[0m"
npm install

echo -e "\e[31m>>>> Copying user service <<<<\e[0m"
cp ${script_path}/user.service /etc/systemd/system/user.service

echo -e "\e[31m>>>> start user services <<<<\e[0m"
systemctl daemon-reload
systemctl enable user
systemctl start user
systemctl restart user

echo -e "\e[31m>>>> Copying mongo repos <<<<\e[0m"
cp {${script_path}}/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>> installing mongo repo and schema <<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m>>>> load schema <<<<\e[0m"
mongo --host mongodb-dev.pavan345.online </app/schema/user.js
systemctl restart user