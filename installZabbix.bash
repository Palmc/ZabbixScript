#!/bin/bash

set -e
printf "\033c"

echo "Enter the password that the PostgreSQL´s zabbix user will have, remember that it is not seen when writing"
read -s -p "Password: " db_pass
echo -e "\n\nType password again"
read -s -p "Password: " db_pass2

while [ "$db_pass" != "$db_pass2" ] ; do
	echo -e "\n\nError, the passwords dont match, try again"
	read -s -p "Password: " db_pass2
done
echo -e "\nSuccess!!"
yum install yum-utils epel-release vim -y
yum install http://rpms.remirepo.net/enterprise/remi-release-7.rpm -y
yum-config-manager --enable remi-php72

rpm -i https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
yum install zabbix-server-pgsql zabbix-web-pgsql zabbix-agent -y

rpm -Uvh https://yum.postgresql.org/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
yum install postgresql10-contrib postgresql10-server -y
/usr/pgsql-10/bin/postgresql-10-setup initdb
systemctl start postgresql-10.service; systemctl enable postgresql-10.service

cd /var/lib/
#sudo -u postgres createuser --pwprompt zabbix
#sudo -u postgres createdb -O zabbix -E Unicode -T template0 zabbix

#sudo -u postgres psql <<EOF
#create user "zabbix" with password '$db_pass2';
#create database zabbix TEMPLATE template0 with owner zabbix;
#GRANT ALL PRIVILEGES ON DATABASE zabbix TO zabbix;
#EOF

sudo -u postgres psql <<EOF
create user "zabbix" with password '$db_pass2';
create database zabbix with owner zabbix;
GRANT ALL PRIVILEGES ON DATABASE zabbix TO zabbix;
EOF

sed -i "s|local   all             all                                     peer|local   all             all                                     trust|g" /var/lib/pgsql/10/data/pg_hba.conf
sed -i "s|host    all             all             127.0.0.1/32            ident|host    all             all             127.0.0.1/32            md5|g" /var/lib/pgsql/10/data/pg_hba.conf
sed -i "s|host    all             all             ::1/128                 ident|host    all             all             ::1/128                 md5|g" /var/lib/pgsql/10/data/pg_hba.conf

systemctl restart postgresql-10.service


#/var/lib/zabbix/.psql_history

zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u zabbix psql zabbix 

sed -i "s|# DBPassword=|DBPassword=$db_pass2|g" /etc/zabbix/zabbix_server.conf

sed -i "s|    <IfModule mod_php5.c>|    <IfModule mod_php7.c>|g" /etc/httpd/conf.d/zabbix.conf
sed -i "s|        # php_value date.timezone Europe/Riga|        php_value date.timezone Europe/Madrid|g" /etc/httpd/conf.d/zabbix.conf

systemctl restart zabbix-server zabbix-agent httpd; systemctl enable zabbix-server zabbix-agent httpd 

echo "############################################"
echo "###############  FINISHED  #################"
echo "############################################"
echo " "
ip=$(hostname -I|cut -f1 -d ' ')
echo -e "Now you must continue here: \e[92mhttp://$ip/zabbix/setup.php\e[0m"
