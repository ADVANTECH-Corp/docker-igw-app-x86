#!/bin/bash
#
# Returns total memory used by process $1 in kb.
#
# See /proc/NNNN/smaps if you want to do something
# more interesting

LOG_PERIOD=120
if [ "$1" == "" ]; then
 echo "time=${LOG_PERIOD}" >> /dev/null
else
  LOG_PERIOD=$1
fi

CONTAINERS="advigw-api-gw advigw-mqtt-bus advigw-hdd-pmq advigw-node-red advigw-wisesnail-dev advigw-wsn-simulator"

services=${services:=${CONTAINERS}}

log_dockerInfo()
{
  echo "Start Log Docker Container"
  #echo `date +"%m/%d %H:%M"` `cat /proc/cpuinfo > systemInfo.log
  #echo `date +"%m/%d %H:%M"` `cat /proc/meminfo >> systemInfo.log	
}


log_docker()
{
  docker stats --no-stream ${CONTAINERS} > 2
  
  for proc in $services; do
  id=$(docker ps | grep $proc | awk '{ print $1 }')
  mem=$(cat 2 | grep $proc | awk 'BEGIN {SUM = 0} { SUM += $3} END { print SUM}')
  unit=$(cat 2 | grep $proc | grep -v grep | sed -re 's/[ ]{1,}/ /g' | cut -d ' ' -f 4 | head -1)
  #echo "Mem $proc $mem $unit" 
  cpu=$(cat 2 | grep $proc | awk 'BEGIN { SUM = 0 } { SUM += $2} END { print SUM }')
  echo `date +"%m/%d %H:%M"`, $proc, $id $mem, $unit  $cpu >> $proc.docker.log
  ##echo $data
  done
}

title()
{
 for proc in $services; do
 if [ -e "$proc.docker.log" ]
   then  
    echo "Found $proc.docker.log"
   else
    echo "date,        name,          id,          mem,      cpu" > $proc.docker.log
 fi
 done
}

log_dockerInfo

title

while true;
do
  log_docker
  sleep $LOG_PERIOD

done

#while true; do clear; ps -eo pcpu,pmem,pid,user,args --sort=-pcpu c|head -20; sleep 1; done
