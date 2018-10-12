# ZabbixScript
Script to install Zabbix 4.0 in CentOS 7 with PostgreSQL

# [Zabbix](https://www.zabbix.com/)-ZabbixScript

**Install instructions**
```
wget -O installZabbix.bash https://raw.github.com/Palmc/ZabbixScript/master/installZabbix.bash
```
Run
```
chmod +x installZabbix.bash
./installZabbix.bash
```
**NOTE**

The default timezone in **/etc/php/7.0/fpm/php.ini** and **/etc/php/7.0/cli/php.ini** is Europe/Madrid, you must change the timezone to adjust it to your location, the list of supported timezones is here: http://php.net/manual/en/timezones.php
