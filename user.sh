script=$(realpath "$0")
script_path=$(dirname "$script")
source $script_path/common.sh

component=user
func_nodejs

echo -e "\e[31m>>>> Copying mongo repos <<<<\e[0m"
cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo

echo -e "\e[31m>>>> installing mongo repo and schema <<<<\e[0m"
yum install mongodb-org-shell -y

echo -e "\e[31m>>>> load schema <<<<\e[0m"
mongo --host mongodb-dev.pavan345.online </app/schema/user.js
systemctl restart user