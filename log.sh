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


#services=${services:="wisesim dockerd test cagent node-red testDustWsnDrv docker-containe mosquitto advigw-restapi node"}

services=${services:="cagent dockerd miniserv.pl"}

log_systemInfo()
{
  echo `date +"%m/%d %H:%M"` `cat /proc/cpuinfo > systemInfo.log
  echo `date +"%m/%d %H:%M"` `cat /proc/meminfo >> systemInfo.log	
}


log_proc()
{
  top -b -n1 > 1
  
  for proc in $services; do
  mem=$(ps aux | grep -w $proc | grep -v grep | sed -re 's/[ ]{1,}/ /g' | cut -d ' ' -f 6 | head -1) 
  pid=$(ps aux | grep -w $proc | grep -v grep | sed -re 's/[ ]{1,}/ /g' | cut -d ' ' -f 2 | head -1)
  cpu=$(cat 1 | grep $proc | awk 'BEGIN { SUM = 0 } { SUM += $9} END { print SUM }')
  #echo "$proc $mem  $cpu"
  echo `date +"%m/%d %H:%M"`, $proc, $pid,   $mem, $cpu >> $proc.log
  #echo $data
  done
  #rm -f 1
  # system
  #mem=$(cat 1 | grep "Mem" | awk 'BEGIN { SUM = 0 } { SUM += $5) END { print SUM }')
  mem=$(cat 1 | grep "Mem" | awk 'BEGIN { SUM = 0 } { SUM += $5 } END { print SUM }')
  cpu=$(cat 1 | grep "%Cpu" | awk 'BEGIN { SUM = 0 } { SUM += $2} END { print SUM }')
  echo `date +"%m/%d %H:%M"`, "system,"   $mem, $cpu >> system.log
}

title()
{
 for proc in $services; do
 if [ -e "$proc.log" ]
   then  
    #echo "date,       name,    pid,    mem(KB),    cpu" > $proc.log  
    echo "Found $proc.log"
   else
    echo "date,       name,    pid,    mem(KB),    cpu" > $proc.log
 fi
 done

 if [ -e "system.log" ]
 then
   echo "Found system.log"
 else 
   echo "data,        name,    mem(KB),    cpu" > system.log
 fi 
}

log_systemInfo

title

./dockerlog.sh $LOG_PERIOD &

while true;
do
  log_proc
  sleep $LOG_PERIOD

done

#while true; do clear; ps -eo pcpu,pmem,pid,user,args --sort=-pcpu c|head -20; sleep 1; done
