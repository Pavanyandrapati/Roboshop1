app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[35m>>>> $1 <<<<\e[0m"
 }

func_app_prereq() {
  func_print_head "add user"
  useradd ${app_user}
  rm -rf /app

  func_print_head "create dir"
  mkdir /app

  func_print_head "Download app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app

  func_print_head "unzip content"
  unzip /tmp/${component}.zip
  cd /app

  }
func_schema_setup() {
  if [ "$schema_setup" == "mongo" ]; then
    func_print_head "Copying mongo repo"
    cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

    func_print_head "installing mongodb"
    yum install mongodb-org-shell -y

    func_print_head "load schema"
     mongo --host mongodb-dev.pavan345.online </app/schema/catalogue.js
  fi
  if [ "${schema_setup}" == "mysql" ]; then

    func_print_head "install mysql"
    yum install mysql -y

    func_print_head "load schema"
    mysql -h mysql-dev.pavan345.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
fi
}
func_systemd_setup() {
 func_print_head"copying ${component service}"
 cp $script_path/${component}.service /etc/systemd/system/${component}.service

 func_print_head start ${component service}"
 systemctl daemon-reload
 systemctl enable ${component}
 systemctl start ${component}
}

  func_nodejs() {

  func_print_head "Downloading content"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash

  func_print_head "install nodejs"
  yum install nodejs -y

  func_app_prereq

  func_print_head "instal dependencies"
  npm install

  func_systemd_setup

  func_schema_setup

  }

  func_java() {
  func_print_head "install maven"
  yum install maven -y

  func_print_head "download maven dependencies"
      mvn clean package
      mv target/${component}-1.0.jar ${component}.jar

  func_app_prereq

  func_systemd_setup
  func_schema_setup
  }

