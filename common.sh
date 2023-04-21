app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")
print_head() {
  echo -e "\e[35m>>>> $1 <<<<\e[0m"
  }
func_nodejs() {
print_head "Downloading content"
curl -sL https://rpm.nodesource.com/setup_lts.x | bash

print_head "install nodejs"
yum install nodejs -y

print_headadd "user"
useradd ${app_user}ALL

print_head "create dir"
rm -rf /app
mkdir /app

print_head "Downloading content"
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app

print_head "unzip content"
unzip /tmp/${component}.zip

print_head "instal dependencies'
npm install

print_head "Copying ${component} service""
cp $script_path/${component}.service /etc/systemd/system/${component}.service

print_headstart cart service 
systemctl daemon-reload
systemctl enable ${component}
systemctl start ${component}

}
}