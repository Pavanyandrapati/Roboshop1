app_user=roboshop
script=$(realpath "$0")
script_path=$(dirname "$script")

func_print_head() {
  echo -e "\e[35m>>>> $1 <<<<\e[0m"
 }

func_stat_check() {

  if [ $? -eq 0 ]; then
     echo -e "\e[32mSUCCESS\e[0m"
  else
     echo -e "\e[32MFAILURE\e[0m"
  fi
}
func_app_prereq() {
  func_print_head "add user"
  useradd ${app_user}
  rm -rf /app

  func_print_head "create dir"
  mkdir /app

  func_print_head "Download app content"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>>$log_file
  cd /app

  func_print_head "unzip content"
  unzip /tmp/${component}.zip &>>$log_file
  cd /app

 }
 func_schema_setup() {
      if [ "$schema_setup" == "mongo" ]; then
     func_print_head "Copying mongo repo"
     cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo &>>$log_file

     func_print_head "installing mongodb"
     yum install mongodb-org-shell -y &>>$log_file

     func_print_head "load schema"
      mongo --host mongodb-dev.pavan345.online </app/schema/catalogue.js &>>$log_file
     fi

     if [ "${schema_setup}" == "mysql" ]; then

     func_print_head "install mysql"
     yum install mysql -y &>>$log_file

     func_print_head "load schema"
      mysql -h mysql-dev.pavan345.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql &>>$log_file
     fi
 }
func_systemd_setup() {

      func_print_head "copying ${component service}"
      cp $script_path/${component}.service /etc/systemd/system/${component}.service &>>$log_file

      func_print_head "${component service}"

      systemctl daemon-reload &>>$log_file
      systemctl enable ${component} &>>$log_file
      systemctl start ${component} &>>$log_file

}
func_nodejs() {

    func_print_head "Downloading content"
    curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$log_file

    func_print_head "install nodejs"
    yum install nodejs -y &>>$log_file
    func_stat_check $?
    func_app_prereq &>>$log_file

    func_print_head "instal dependencies"
    npm install &>>$log_file
    func_stat_check $?
    func_schema_setup &>>$log_file
    func_stat_check $?
    func_systemd_setup &>>$log_file
    func_stat_check $?

}

func_java() {
     func_print_head "install maven"
      yum install maven -y &>>$log_file
       func_stat_check $?
      func_print_head "download maven dependencies"
          mvn clean package &>>$log_file
          mv target/${component}-1.0.jar ${component}.jar &>>$log_file
      func_stat_check $?
      func_app_prereq &>>$log_file

      func_systemd_setup &>>$log_file
      func_stat_check $?
      func_schema_setup &>>$log_file
      func_stat_check $?
}