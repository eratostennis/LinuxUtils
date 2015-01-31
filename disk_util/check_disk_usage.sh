#!/bin/sh

HOSTS=""
STATUS=0
disk_usage=100
#for host in $HOSTS; do
  #disk_usage=`ssh $host -e "df" | head -n 2 | tail -n 1 | awk '{ print $5 }'`
  if [ $disk_usage -gt 80 ];then
    echo "[WARNING] ${host}'s disk usage is $disk_usage."
	STATUS=1
  else
    echo "[     OK] ${host}'s disk usage is $disk_usage."
	STATUS=1
  fi
#done
exit $STATUS
