app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_nodejs() {
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
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

echo -e "\e[31m>>>> unzip content <<<<\e[0m"
unzip /tmp/${component}.zip

echo -e "\e[31m>>>> instal dependencies <<<<\e[0m"
npm install

echo -e "\e[31m>>>> Copying ${component} service <<<<\e[0m"
cp $script_path/${component}.service /etc/systemd/system/${component}.service

echo -e "\e[31m>>>> start cart service <<<<\e[0m"
systemctl daemon-reload
systemctl enable ${component}
systemctl start ${component}

}