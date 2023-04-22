script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh
mysql_root_password=$1
if [ -z "$mysql_root_password"];then
  echo input missing
  exit
fi
func_print_head "disable mysql"
dnf module disable mysql -y &>>$log_file

func_print_head "Copying mysql repo"
cp $script_path/mysql.repo /etc/yum.repos.d/mysql.repo &>>$log_file

func_print_head "install mysql"
yum install mysql-community-server -y &>>$log_file

func_print_head "start mysql service"
systemctl enable mysqld &>>$log_file
systemctl start mysqld &>>$log_file

func_print_head "reset mysql password"
mysql_secure_installation --set-root-pass $mysql_root_password &>>$log_file
systemctl restart mysqld &>>$log_file