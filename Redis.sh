echo -e "\e[31m>>>> install remirepo <<<<\e[0m"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y

echo -e "\e[31m>>>> enable redis <<<<\e[0m"
dnf module enable redis:remi-6.2 -y

echo -e "\e[31m>>>> install redis <<<<\e[0m"
yum install redis -y

echo -e "\e[31m>>>> change host <<<<\e[0m"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis.conf /etc/redis/redis.conf

echo -e "\e[31m>>>> start redis servic <<<<\e[0m"
systemctl enable redis
systemctl start redis
systemctl restart redis