# [Zabbix](https://www.zabbix.com/)Script

Script to install Zabbix 4.0, tested on Debian 9, Ubuntu 18 and CentOS 7 

**Install instructions**

With wget:
```
wget -O installZabbix.bash https://raw.github.com/Palmc/ZabbixScript/master/installZabbix.bash && bash installZabbix.bash
```
With curl:
```
curl -L https://raw.github.com/Palmc/ZabbixScript/master/installZabbix.bash > installZabbix.bash && bash installZabbix.bash
```
**NOTE**

The default timezone in **/etc/httpd/conf.d/zabbix.conf** or **/etc/zabbix/apache.conf** is Europe/Madrid, you must change the timezone to adjust it to your location, the list of supported timezones is here: http://php.net/manual/en/timezones.php
