#!/bin/bash

set -e
printf "\033c"

setTimeZone(){
	# Set time zone
	read -p "Enter the time zone: " time_zone
}

setPsqlUser(){
	# Set PostgreSQL user name
	read -p "Enter the PostgreSQL user name: " psql_user
}

setPsqlPassword(){
	# Set password of PostgreSQL's $psql_user user
	echo "Enter the password that the PostgreSQL's $psql_user user will have."
	while true; do
		read -s -p "Password: " psql_pass
		read -s -p "Type password again: " psql_pass2
		[ "$psql_pass" = "$psql_pass2" ] && break
		echo -e "\nError, please try again"
	done
	echo -e "\n\e[92mSucess!!\e[0m"
}

setPsqlDbName(){
	# Set PostgreSQL database name
	read -p "Enter the PostgreSQL database name: " psql_db_name
}

installCentos(){
	# Detect SElinux status
	SELINUXSTATUS=$(getenforce)
	if [ "$SELINUXSTATUS" == "Enforcing" ]; then
		echo "SElinux is set as Enforcing, disable it or adjust your configuration"
		read -p "Would you like to change it to permissive? " ans
		case "$ans" in
			[yY]|[yY][eE][sS]) setenforce 0 && echo -e "\n\e[92mSucess!!\e[0m" ;;
			*) read -n 1 -s -r -p "Press any key to continue" ;;
		esac
		echo -e "\n"
	fi
	
	# Adding repositories
	yum -y install yum-utils epel-release
	rpm -Uvh http://rpms.remirepo.net/enterprise/remi-release-7.rpm
	rpm -Uvh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
	rpm -Uvh https://yum.postgresql.org/10/redhat/rhel-7-x86_64/pgdg-centos10-10-2.noarch.rpm
	yum-config-manager --enable remi-php72
	
	# Installing Zabbix components and PostgreSQL
	
	yum -y install zabbix-server-pgsql zabbix-web-pgsql zabbix-agent postgresql10-contrib postgresql10-server

	/usr/pgsql-10/bin/postgresql-10-setup initdb
	systemctl start postgresql-10.service; systemctl enable postgresql-10.service

	cd /var/lib

	sudo -u postgres psql <<EOF
		create user "$psql_user" with password '$psql_pass';
		create database "$psql_db_name" with owner "$psql_user";
		GRANT ALL PRIVILEGES ON DATABASE "$psql_db_name" TO "$psql_user";
EOF
	sed -i "s|local   all             all                                     peer|local   all             all                                     trust|g" /var/lib/pgsql/10/data/pg_hba.conf
	sed -i "s|host    all             all             127.0.0.1/32            ident|host    all             all             127.0.0.1/32            md5|g" /var/lib/pgsql/10/data/pg_hba.conf
	sed -i "s|host    all             all             ::1/128                 ident|host    all             all             ::1/128                 md5|g" /var/lib/pgsql/10/data/pg_hba.conf

	systemctl restart postgresql-10.service

	zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u "$psql_user" psql "$psql_db_name" 

	sed -i "s|# DBPassword=|DBPassword=$psql_pass|g" /etc/zabbix/zabbix_server.conf
	sed -i "s|    <IfModule mod_php5.c>|    <IfModule mod_php7.c>|g" /etc/httpd/conf.d/zabbix.conf
	sed -i "s|        # php_value date.timezone Europe/Riga|        php_value date.timezone $time_zone|g" /etc/httpd/conf.d/zabbix.conf

	systemctl restart zabbix-server zabbix-agent httpd; systemctl enable zabbix-server zabbix-agent httpd

	# I (tukusejssirs) had an error in http://$ip/zabbix/setup.php, when it checked the pre-requisities,
	# particularly with "Assets cache directory permissions", which was read-only
	# The following command fixes this error (I have no idea if it is needed in other distros, too)
	chmod -R 777 /usr/share/zabbix/assets
}

installDebianBased() {
	# Adding repositories
	wget https://repo.zabbix.com/zabbix/4.0/$ID/pool/main/z/zabbix-release/zabbix-release_4.0-2+$(lsb_release -cs)_all.deb
	dpkg -i zabbix-release_4.0-2+$(lsb_release -cs)_all.deb
	wget -q https://www.postgresql.org/media/keys/ACCC4CF8.asc -O- | apt-key add -
	echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/postgresql.list
	apt update


	# Installing Zabbix components and PostgreSQL
	apt install -y zabbix-server-pgsql zabbix-frontend-php php-pgsql zabbix-agent postgresql-10

	cd /var/lib/postgresql/
	systemctl start postgresql; systemctl enable postgresql
	sudo -u postgres psql <<EOF
		create user "$psql_user" with password '$psql_pass';
		create database "$psql_db_name" with owner "$psql_user";
		GRANT ALL PRIVILEGES ON DATABASE "$psql_db_name" TO "$psql_user";
EOF

	zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz | sudo -u "$psql_user" psql "$psql_db_name"


	sed -i "s|# DBPassword=|DBPassword=$psql_pass|g" /etc/zabbix/zabbix_server.conf
	sed -i "s|        # php_value date.timezone Europe/Riga|        php_value date.timezone $time_zone|g" /etc/zabbix/apache.conf

	systemctl restart zabbix-server zabbix-agent apache2; systemctl enable zabbix-server zabbix-agent apache2 
}

installRaspbian(){
	#Adding repositories
	wget https://repo.zabbix.com/zabbix/4.0/$ID/pool/main/z/zabbix-release/zabbix-release_4.0-2+$(lsb_release -cs)_all.deb
	dpkg -i zabbix-release_4.0-2+$(lsb_release -cs)_all.deb
	apt update
	
	#Installing Zabbix components and PostgreSQL
	apt install -y zabbix-server-pgsql zabbix-frontend-php php-pgsql zabbix-agent postgresql
	cd /var/lib/postgresql/
	systemctl start postgresql; systemctl enable postgresql
	sudo -u postgres psql <<EOF
		create user "$psql_user" with password '$psql_pass';
		create database "$psql_db_name" with owner "$psql_user";
		GRANT ALL PRIVILEGES ON DATABASE "$psql_db_name" TO "$psql_user";
EOF

	zcat /usr/share/doc/zabbix-server-pgsql/create.sql.gz | sudo -u "$psql_user" psql "$psql_db_name"

	sed -i "s|# DBPassword=|DBPassword=$psql_pass|g" /etc/zabbix/zabbix_server.conf
	sed -i "s|        # php_value date.timezone Europe/Riga|        php_value date.timezone $time_zone|g" /etc/zabbix/apache.conf

	systemctl restart zabbix-server zabbix-agent apache2; systemctl enable zabbix-server zabbix-agent apache2 
}

# Detect distribution
source /etc/os-release
setTimeZone
setPsqlUser
setPsqlPassword
setPsqlDbName
case $ID in
	centos)
		installCentos
		;;
	debian|ubuntu)
		installDebianBased
		;;
	raspbian)
		installRaspbian
		;;
	*)
		echo "Distribution $ID is currently not supported."
		exit 1
		;;
esac

echo "############################################"
echo "###############  FINISHED  #################"
echo "############################################"
echo " "
ip=$(hostname -I|cut -f1 -d ' ')
echo -e "Now you must continue here: \e[92mhttp://$ip/zabbix/setup.php\e[0m"
echo -e "\nIn the web interface:"
echo -e "Default user:     \e[33mAdmin\e[0m"
echo -e "Default password: \e[33mzabbix\e[0m"
