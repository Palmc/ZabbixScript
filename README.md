# [Zabbix](https://www.zabbix.com/)-ZabbixScript

Script to install Zabbix 4.0 in CentOS 7 with PostgreSQL

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

The default timezone in **/etc/httpd/conf.d/zabbix.conf** is Europe/Madrid, you must change the timezone to adjust it to your location, the list of supported timezones is here: http://php.net/manual/en/timezones.php
