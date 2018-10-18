#!/bin/bash

set -e
printf "\033c"

setPassword(){
	#Set password of PostgreSQL´s zabbix user
	echo "Enter the password that the PostgreSQL´s zabbix user will have"
	while true; do
		echo -e "\n"
		read -s -p "Password: " db_pass
		echo -e "\n"
		read -s -p "Type password again: " db_pass2
	 	[ "$db_pass" = "$db_pass2" ] && break
		echo -e "\nError, please try again"
	done
	echo -e "\n\e[92mSucess!!\e[0m"
}

installCentos(){
	#Detect SElinux status
	SELINUXSTATUS=$(getenforce)
	if [ "$SELINUXSTATUS" == "Enforcing" ]; then
		echo "SElinux is set as Enforcing, disable it or adjust your configuration"
		read -n 1 -s -r -p "Press any key to continue"
		echo -e "\n"
	fi;
	
	#Adding repositories
	yum install yum-utils epel-release -y
	rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
	rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
	rpm -Uvh https://yum.postgresql.org/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
	yum-config-manager --enable remi-php72
	
	#Installing Zabbix components and PostgreSQL
	
	yum install zabbix-server-pgsql zabbix-web-pgsql zabbix-agent postgresql10-contrib postgresql10-server -y

	/usr/pgsql-10/bin/postgresql-10-setup initdb
	systemctl start postgresql-10.service; systemctl enable postgresql-10.service

	cd /var/lib/

	sudo -u postgres psql <<EOF
		create user "zabbix" with password '$db_pass2';
		create database zabbix with owner zabbix;
		GRANT ALL PRIVILEGES ON DATABASE zabbix TO zabbix;
EOF
	sed -i "s|local   all             all                                     peer|local   all             all                                     trust|g" /var/lib/pgsql/10/data/pg_hba.conf
	sed -i "s|host    all             all             127.0.0.1/32            ident|host    all             all             127.0.0.1/32            md5|g" /var/lib/pgsql/10/data/pg_hba.conf
	sed -i "s|host    all             all             ::1/128                 ident|host    all             all             ::1/128                 md5|g" /var/lib/pgsql/10/data/pg_hba.conf

	systemctl restart postgresql-10.service

	zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u zabbix psql zabbix 

	sed -i "s|# DBPassword=|DBPassword=$db_pass2|g" /etc/zabbix/zabbix_server.conf
	sed -i "s|    <IfModule mod_php5.c>|    <IfModule mod_php7.c>|g" /etc/httpd/conf.d/zabbix.conf
	sed -i "s|        # php_value date.timezone Europe/Riga|        php_value date.timezone Europe/Madrid|g" /etc/httpd/conf.d/zabbix.conf

	systemctl restart zabbix-server zabbix-agent httpd; systemctl enable zabbix-server zabbix-agent httpd 
}

installDebianBased() {
	#Adding repositories
	wget https://repo.zabbix.com/zabbix/4.0/$ID/pool/main/z/zabbix-release/zabbix-release_4.0-2+`lsb_release -cs`_all.deb
	dpkg -i zabbix-release_4.0-2+`lsb_release -cs`_all.deb
	wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | apt-key add -
	echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee /etc/apt/sources.list.d/postgresql.list
	apt update


	#Installing Zabbix components and PostgreSQL
	apt install -y zabbix-server-pgsql zabbix-frontend-php php-pgsql zabbix-agent postgresql-10 sudo

	cd /var/lib/postgresql/
	systemctl start postgresql; systemctl enable postgresql
	sudo -u postgres psql <<EOF
		create user "zabbix" with password '$db_pass2';
		create database zabbix with owner zabbix;
		GRANT ALL PRIVILEGES ON DATABASE zabbix TO zabbix;
EOF

	zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz | sudo -u zabbix psql zabbix


	sed -i "s|# DBPassword=|DBPassword=$db_pass2|g" /etc/zabbix/zabbix_server.conf
	sed -i "s|        # php_value date.timezone Europe/Riga|        php_value date.timezone Europe/Madrid|g" /etc/zabbix/apache.conf

	systemctl restart zabbix-server zabbix-agent apache2; systemctl enable zabbix-server zabbix-agent apache2 
}

installRaspbian(){
	#Adding repositories
	wget https://repo.zabbix.com/zabbix/4.0/$ID/pool/main/z/zabbix-release/zabbix-release_4.0-2+`lsb_release -cs`_all.deb
	dpkg -i zabbix-release_4.0-2+`lsb_release -cs`_all.deb
	apt update
	
	#Installing Zabbix components and PostgreSQL
	apt install -y zabbix-server-pgsql zabbix-frontend-php php-pgsql zabbix-agent postgresql
	cd /var/lib/postgresql/
	systemctl start postgresql; systemctl enable postgresql
	sudo -u postgres psql <<EOF
		create user "zabbix" with password '$db_pass2';
		create database zabbix with owner zabbix;
		GRANT ALL PRIVILEGES ON DATABASE zabbix TO zabbix;
EOF

	zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz | sudo -u zabbix psql zabbix

	sed -i "s|# DBPassword=|DBPassword=$db_pass2|g" /etc/zabbix/zabbix_server.conf
	sed -i "s|        # php_value date.timezone Europe/Riga|        php_value date.timezone Europe/Madrid|g" /etc/zabbix/apache.conf

	systemctl restart zabbix-server zabbix-agent apache2; systemctl enable zabbix-server zabbix-agent apache2 
}

#Detect distrib
source /etc/os-release
case $ID in
	centos)
		setPassword
		installCentos
		;;
	debian|ubuntu)
		setPassword
		installDebianBased
		;;
	raspbian)
		setPassword
		installRaspbian
		;;
	*)
		echo "Distribution not supported"
		exit 1
		;;
esac

echo "############################################"
echo "###############  FINISHED  #################"
echo "############################################"
echo " "
ip=$(hostname -I|cut -f1 -d ' ')
echo -e "Now you must continue here: \e[92mhttp://$ip/zabbix/setup.php\e[0m"
echo -e "\nOn web interface:"
echo -e "Default user: \e[33mAdmin\e[0m"
echo -e "Default password: \e[33mzabbix\e[0m"
