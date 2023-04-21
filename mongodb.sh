echo -e "\e[31m>>>> Copying mongo repo <<<<\e[0m"
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
echo -e "\e[31m>>>> install mongodb <<<<\e[0m"
yum install mongodb-org -y
echo -e "\e[31m>>>> start mongodb services <<<<\e[0m"
systemctl enable mongod
systemctl start mongod
echo -e "\e[31m>>>> change host <<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
systemctl restart mongod
