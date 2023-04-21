script_path=${dirname $0}
source $script_path/common.sh
echo -e "\e[31m>>>> installing nginx <<<<\e[0m"
yum install nginx -y
echo -e "\e[31m>>>> start nginx services <<<<\e[0m"
systemctl enable nginx
systemctl start nginx
echo -e "\e[31m>>>> removing content <<<<\e[0m"
rm -rf /usr/share/nginx/html/*
echo -e "\e[31m>>>> Downloading content <<<<\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
echo -e "\e[31m>>>> unzip content <<<<\e[0m"
unzip /tmp/frontend.zip
echo -e "\e[31m>>>> Copying roboshop serives <<<<\e[0m"
cp $script_path /roboshop.service /etc/nginx/default.d/roboshop.conf
systemctl restart nginx