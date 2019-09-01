#!/bin/bash

set -e
printf "\033c"

setTimeZone(){
    # Declare time zones available
    declare -a timezones=(
    "America/Adak",
    "America/Argentina/Buenos_Aires",
    "America/Argentina/La_Rioja",
    "America/Argentina/San_Luis",
    "America/Atikokan",
    "America/Belem",
    "America/Boise",
    "America/Caracas",
    "America/Chihuahua",
    "America/Cuiaba",
    "America/Denver",
    "America/El_Salvador",
    "America/Godthab",
    "America/Guatemala",
    "America/Hermosillo",
    "America/Indiana/Tell_City",
    "America/Inuvik",
    "America/Kentucky/Louisville",
    "America/Lima",
    "America/Managua",
    "America/Mazatlan",
    "America/Mexico_City",
    "America/Montreal",
    "America/Nome",
    "America/Ojinaga",
    "America/Port-au-Prince",
    "America/Rainy_River",
    "America/Rio_Branco",
    "America/Santo_Domingo",
    "America/St_Barthelemy",
    "America/St_Vincent",
    "America/Tijuana",
    "America/Whitehorse",
    "America/Anchorage",
    "America/Argentina/Catamarca",
    "America/Argentina/Mendoza",
    "America/Argentina/Tucuman",
    "America/Atka",
    "America/Belize",
    "America/Buenos_Aires",
    "America/Catamarca",
    "America/Coral_Harbour",
    "America/Curacao",
    "America/Detroit",
    "America/Ensenada",
    "America/Goose_Bay",
    "America/Guayaquil",
    "America/Indiana/Indianapolis",
    "America/Indiana/Vevay",
    "America/Iqaluit",
    "America/Kentucky/Monticello",
    "America/Los_Angeles",
    "America/Manaus",
    "America/Mendoza",
    "America/Miquelon",
    "America/Montserrat",
    "America/Noronha",
    "America/Panama",
    "America/Port_of_Spain",
    "America/Rankin_Inlet",
    "America/Rosario",
    "America/Sao_Paulo",
    "America/St_Johns",
    "America/Swift_Current",
    "America/Toronto",
    "America/Winnipeg",
    "America/Anguilla",
    "America/Argentina/ComodRivadavia",
    "America/Argentina/Rio_Gallegos",
    "America/Argentina/Ushuaia",
    "America/Bahia",
    "America/Blanc-Sablon",
    "America/Cambridge_Bay",
    "America/Cayenne",
    "America/Cordoba",
    "America/Danmarkshavn",
    "America/Dominica",
    "America/Fort_Wayne",
    "America/Grand_Turk",
    "America/Guyana",
    "America/Indiana/Knox",
    "America/Indiana/Vincennes",
    "America/Jamaica",
    "America/Knox_IN",
    "America/Louisville",
    "America/Marigot",
    "America/Menominee",
    "America/Moncton",
    "America/Nassau",
    "America/North_Dakota/Beulah",
    "America/Pangnirtung",
    "America/Porto_Acre",
    "America/Recife",
    "America/Santa_Isabel",
    "America/Scoresbysund",
    "America/St_Kitts",
    "America/Tegucigalpa",
    "America/Tortola",
    "America/Yakutat",
    "America/Antigua",
    "America/Argentina/Cordoba",
    "America/Argentina/Salta",
    "America/Aruba",
    "America/Bahia_Banderas",
    "America/Boa_Vista",
    "America/Campo_Grande",
    "America/Cayman",
    "America/Costa_Rica",
    "America/Dawson",
    "America/Edmonton",
    "America/Fortaleza",
    "America/Grenada",
    "America/Halifax",
    "America/Indiana/Marengo",
    "America/Indiana/Winamac",
    "America/Jujuy",
    "America/Kralendijk",
    "America/Lower_Princes",
    "America/Martinique",
    "America/Merida",
    "America/Monterrey",
    "America/New_York",
    "America/North_Dakota/Center",
    "America/Paramaribo",
    "America/Porto_Velho",
    "America/Regina",
    "America/Santarem",
    "America/Shiprock",
    "America/St_Lucia",
    "America/Thule",
    "America/Vancouver",
    "America/Yellowknife",
    "America/Araguaina",
    "America/Argentina/Jujuy",
    "America/Argentina/San_Juan",
    "America/Asuncion",
    "America/Barbados",
    "America/Bogota",
    "America/Cancun",
    "America/Chicago",
    "America/Creston",
    "America/Dawson_Creek",
    "America/Eirunepe",
    "America/Glace_Bay",
    "America/Guadeloupe",
    "America/Havana",
    "America/Indiana/Petersburg",
    "America/Indianapolis",
    "America/Juneau",
    "America/La_Paz",
    "America/Maceio",
    "America/Matamoros",
    "America/Metlakatla",
    "America/Montevideo",
    "America/Nipigon",
    "America/North_Dakota/New_Salem",
    "America/Phoenix",
    "America/Puerto_Rico",
    "America/Resolute",
    "America/Santiago",
    "America/Sitka",
    "America/St_Thomas",
    "America/Thunder_Bay",
    "America/Virgin",
    "Indian/Antananarivo",
    "Indian/Kerguelen",
    "Indian/Reunion",
    "Australia/ACT",
    "Australia/Currie",
    "Australia/Lindeman",
    "Australia/Perth",
    "Australia/Victoria",
    "Europe/Amsterdam",
    "Europe/Berlin",
    "Europe/Chisinau",
    "Europe/Helsinki",
    "Europe/Kiev",
    "Europe/Madrid",
    "Europe/Moscow",
    "Europe/Prague",
    "Europe/Sarajevo",
    "Europe/Tallinn",
    "Europe/Vatican",
    "Europe/Zagreb",
    "Pacific/Apia",
    "Pacific/Efate",
    "Pacific/Galapagos",
    "Pacific/Johnston",
    "Pacific/Marquesas",
    "Pacific/Noumea",
    "Pacific/Ponape",
    "Pacific/Tahiti",
    "Pacific/Wallis",
    "Indian/Chagos",
    "Indian/Mahe",
    "Australia/Adelaide",
    "Australia/Darwin",
    "Australia/Lord_Howe",
    "Australia/Queensland",
    "Australia/West",
    "Europe/Andorra",
    "Europe/Bratislava",
    "Europe/Copenhagen",
    "Europe/Isle_of_Man",
    "Europe/Lisbon",
    "Europe/Malta",
    "Europe/Nicosia",
    "Europe/Riga",
    "Europe/Simferopol",
    "Europe/Tirane",
    "Europe/Vienna",
    "Europe/Zaporozhye",
    "Pacific/Auckland",
    "Pacific/Enderbury",
    "Pacific/Gambier",
    "Pacific/Kiritimati",
    "Pacific/Midway",
    "Pacific/Pago_Pago",
    "Pacific/Port_Moresby",
    "Pacific/Tarawa",
    "Pacific/Yap",
    "Africa/Abidjan",
    "Africa/Asmera",
    "Africa/Blantyre",
    "Africa/Ceuta",
    "Africa/Douala",
    "Africa/Johannesburg",
    "Africa/Kinshasa",
    "Africa/Lubumbashi",
    "Africa/Mbabane",
    "Africa/Niamey",
    "Africa/Timbuktu",
    "Africa/Accra",
    "Africa/Bamako",
    "Africa/Brazzaville",
    "Africa/Conakry",
    "Africa/El_Aaiun",
    "Africa/Juba",
    "Africa/Lagos",
    "Africa/Lusaka",
    "Africa/Mogadishu",
    "Africa/Nouakchott",
    "Africa/Tripoli",
    "Africa/Addis_Ababa",
    "Africa/Bangui",
    "Africa/Bujumbura",
    "Africa/Dakar",
    "Africa/Freetown",
    "Africa/Kampala",
    "Africa/Libreville",
    "Africa/Malabo",
    "Africa/Monrovia",
    "Africa/Ouagadougou",
    "Africa/Tunis",
    "Africa/Algiers",
    "Africa/Banjul",
    "Africa/Cairo",
    "Africa/Dar_es_Salaam",
    "Africa/Gaborone",
    "Africa/Khartoum",
    "Africa/Lome",
    "Africa/Maputo",
    "Africa/Nairobi",
    "Africa/Porto-Novo",
    "Africa/Windhoek",
    "Africa/Asmara",
    "Africa/Bissau",
    "Africa/Casablanca",
    "Africa/Djibouti",
    "Africa/Harare",
    "Africa/Kigali",
    "Africa/Luanda",
    "Africa/Maseru",
    "Africa/Ndjamena",
    "Africa/Sao_Tome",
    "Atlantic/Azores",
    "Atlantic/Faroe",
    "Atlantic/St_Helena",
    "Atlantic/Bermuda",
    "Atlantic/Jan_Mayen",
    "Atlantic/Stanley",
    "Atlantic/Canary",
    "Atlantic/Madeira",
    "Atlantic/Cape_Verde",
    "Atlantic/Reykjavik",
    "Atlantic/Faeroe",
    "Atlantic/South_Georgia",
    "Asia/Aden",
    "Asia/Aqtobe",
    "Asia/Baku",
    "Asia/Calcutta",
    "Asia/Dacca",
    "Asia/Dushanbe",
    "Asia/Hong_Kong",
    "Asia/Jayapura",
    "Asia/Kashgar",
    "Asia/Kuala_Lumpur",
    "Asia/Magadan",
    "Asia/Novokuznetsk",
    "Asia/Pontianak",
    "Asia/Riyadh",
    "Asia/Shanghai",
    "Asia/Tehran",
    "Asia/Ujung_Pandang",
    "Asia/Vladivostok",
    "Asia/Almaty",
    "Asia/Ashgabat",
    "Asia/Bangkok",
    "Asia/Choibalsan",
    "Asia/Damascus",
    "Asia/Gaza",
    "Asia/Hovd",
    "Asia/Jerusalem",
    "Asia/Kathmandu",
    "Asia/Kuching",
    "Asia/Makassar",
    "Asia/Novosibirsk",
    "Asia/Pyongyang",
    "Asia/Saigon",
    "Asia/Singapore",
    "Asia/Tel_Aviv",
    "Asia/Ulaanbaatar",
    "Asia/Yakutsk",
    "Asia/Amman",
    "Asia/Ashkhabad",
    "Asia/Beirut",
    "Asia/Chongqing",
    "Asia/Dhaka",
    "Asia/Harbin",
    "Asia/Irkutsk",
    "Asia/Kabul",
    "Asia/Katmandu",
    "Asia/Kuwait",
    "Asia/Manila",
    "Asia/Omsk",
    "Asia/Qatar",
    "Asia/Sakhalin",
    "Asia/Taipei",
    "Asia/Thimbu",
    "Asia/Ulan_Bator",
    "Asia/Yekaterinburg",
    "Asia/Anadyr",
    "Asia/Baghdad",
    "Asia/Bishkek",
    "Asia/Chungking",
    "Asia/Dili",
    "Asia/Hebron",
    "Asia/Istanbul",
    "Asia/Kamchatka",
    "Asia/Kolkata",
    "Asia/Macao",
    "Asia/Muscat",
    "Asia/Oral",
    "Asia/Qyzylorda",
    "Asia/Samarkand",
    "Asia/Tashkent",
    "Asia/Thimphu",
    "Asia/Urumqi",
    "Asia/Yerevan",
    "Asia/Aqtau",
    "Asia/Bahrain",
    "Asia/Brunei",
    "Asia/Colombo",
    "Asia/Dubai",
    "Asia/Ho_Chi_Minh",
    "Asia/Jakarta",
    "Asia/Karachi",
    "Asia/Krasnoyarsk",
    "Asia/Macau",
    "Asia/Nicosia",
    "Asia/Phnom_Penh",
    "Asia/Rangoon",
    "Asia/Seoul",
    "Asia/Tbilisi",
    "Asia/Tokyo",
    "Asia/Vientiane",
    "Australia/Canberra",
    "Australia/LHI",
    "Australia/NSW",
    "Australia/Tasmania",
    "Australia/Broken_Hill",
    "Australia/Hobart",
    "Australia/North",
    "Australia/Sydney",
    "Pacific/Chuuk",
    "Pacific/Fiji",
    "Pacific/Guam",
    "Pacific/Kwajalein",
    "Pacific/Niue",
    "Pacific/Pitcairn",
    "Pacific/Saipan",
    "Pacific/Truk",
    "Pacific/Chatham",
    "Pacific/Fakaofo",
    "Pacific/Guadalcanal",
    "Pacific/Kosrae",
    "Pacific/Nauru",
    "Pacific/Palau",
    "Pacific/Rarotonga",
    "Pacific/Tongatapu",
    "Pacific/Easter",
    "Pacific/Funafuti",
    "Pacific/Honolulu",
    "Pacific/Majuro",
    "Pacific/Norfolk",
    "Pacific/Pohnpei",
    "Pacific/Samoa",
    "Pacific/Wake",
    "Antarctica/Casey",
    "Antarctica/McMurdo",
    "Antarctica/Vostok",
    "Antarctica/Davis",
    "Antarctica/Palmer",
    "Antarctica/DumontDUrville",
    "Antarctica/Rothera",
    "Antarctica/Macquarie",
    "Antarctica/South_Pole",
    "Antarctica/Mawson",
    "Antarctica/Syowa",
    "Arctic/Longyearbyen",
    "Europe/Athens",
    "Europe/Brussels",
    "Europe/Dublin",
    "Europe/Istanbul",
    "Europe/Ljubljana",
    "Europe/Mariehamn",
    "Europe/Oslo",
    "Europe/Rome",
    "Europe/Skopje",
    "Europe/Tiraspol",
    "Europe/Vilnius",
    "Europe/Zurich",
    "Europe/Belfast",
    "Europe/Bucharest",
    "Europe/Gibraltar",
    "Europe/Jersey",
    "Europe/London",
    "Europe/Minsk",
    "Europe/Paris",
    "Europe/Samara",
    "Europe/Sofia",
    "Europe/Uzhgorod",
    "Europe/Volgograd",
    "Europe/Belgrade",
    "Europe/Budapest",
    "Europe/Guernsey",
    "Europe/Kaliningrad",
    "Europe/Luxembourg",
    "Europe/Monaco",
    "Europe/Podgorica",
    "Europe/San_Marino",
    "Europe/Stockholm",
    "Europe/Vaduz",
    "Europe/Warsaw",
    "Indian/Cocos",
    "Indian/Mauritius",
    "Indian/Christmas",
    "Indian/Maldives",
    "Indian/Comoro",
    "Indian/Mayotte",
    "Australia/Brisbane",
    "Australia/Eucla",
    "Australia/Melbourne",
    "Australia/South",
    "Australia/Yancowinna",
    );
        # Set time zone
        IFS=$','
        read -p "Enter the time zone [UTC]: " time_zone
	# Permit fail the following line
	set +e
        printf '%s\n' ${timezones[@]} | grep -P "^$time_zone$" > /dev/null
        local error=$?
	set -e
        if [[ $error != "0" ]]; then
                        echo "Timezone not supported"
                        echo "List of supported timezones: http://php.net/manual/en/timezones.php"
                        exit 1
        fi
        time_zone=${time_zone:-UTC}
        unset IFS
}


setPsqlUser(){
	# Set PostgreSQL user name
	read -p "Enter the PostgreSQL user name [zabbix]: " psql_user
	psql_user=${psql_user:-zabbix}
}

setPsqlPassword(){
	# Set password of PostgreSQL's $psql_user user
	echo "Enter the password that the PostgreSQL's $psql_user user will have."
	while true; do
		read -s -p $'\n'"Password: " psql_pass
		read -s -p $'\n'"Type password again: " psql_pass2
		[ "$psql_pass" = "$psql_pass2" ] && break
		echo -e "\nError, please try again"
	done
	echo -e "\n\e[92mSucess!!\e[0m"
}

setPsqlDbName(){
	# Set PostgreSQL database name
	read -p "Enter the PostgreSQL database name [zabbix]: " psql_db_name
	psql_db_name=${psql_db_name:-zabbix}
}

installCentos(){
	# Detect SElinux status
	SELINUXSTATUS=$(getenforce)
	if [ "$SELINUXSTATUS" == "Enforcing" ]; then
		echo "SElinux is set as Enforcing, disable it or adjust your configuration"
		read -p "Would you like to change it to permissive? " ans
		case "$ans" in
			[yY]|[yY][eE][sS]) 
				sed -i s/^SELINUX=.*$/SELINUX=permissive/ /etc/sysconfig/selinux
				setenforce 0 && echo -e "\n\e[92mSucess!!\e[0m" 
				;;
			*)
				read -n 1 -s -r -p "Press any key to continue" 
				;;
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
	sed -r -i "s|(^local\s*all\s*all\s*)peer$|\1trust|g" /var/lib/pgsql/10/data/pg_hba.conf
	sed -r -i "s|(^host\s*all\s*all\s*127.0.0.1/32\s*)ident$|\1md5|g" /var/lib/pgsql/10/data/pg_hba.conf
	sed -r -i "s|(^host\s*all\s*all\s*::1/128\s*)ident$|\1md5|g" /var/lib/pgsql/10/data/pg_hba.conf

	systemctl restart postgresql-10.service

	zcat /usr/share/doc/zabbix-server-pgsql*/create.sql.gz | sudo -u "$psql_user" psql "$psql_db_name" 

	sed -i "s|# DBPassword=|DBPassword=$psql_pass|g" /etc/zabbix/zabbix_server.conf
	sed -i "s|    <IfModule mod_php5.c>|    <IfModule mod_php7.c>|g" /etc/httpd/conf.d/zabbix.conf
	sed -i -r "s|(^\s+)#\s+(.*timezone\s+)Europe\/Riga$|\1\2$time_zone|g" /etc/httpd/conf.d/zabbix.conf

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
	sed -i -r "s|(^\s+)#\s+(.*timezone\s+)Europe\/Riga$|\1\2$time_zone|g" /etc/zabbix/apache.conf

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
	sed -i -r "s|(^\s+)#\s+(.*timezone\s+)Europe\/Riga$|\1\2$time_zone|g" /etc/zabbix/apache.conf

	systemctl restart zabbix-server zabbix-agent apache2; systemctl enable zabbix-server zabbix-agent apache2 
}

# Ensure distribution is compatible
if [ ! -f /etc/os-release ]
then
        echo "Distribution not supported"
        exit 1
fi

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
