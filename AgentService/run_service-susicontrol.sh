#!/bin/bash

ServiceName=EService-SUSIControl

if [ ! -d "/home/adv/$ServiceName" ]; then
        mkdir /home/adv/$ServiceName
        mkdir /home/adv/$ServiceName/config
        cp /usr/local/$ServiceName/agent_config.xml /home/adv/$ServiceName/config/.
fi


if [ ! -d "/home/adv/$ServiceName/config/agent_config.xml" ]; then
        cp /home/adv/$ServiceName/config/agent_config.xml /usr/local/$ServiceName/.
fi

if [ ! -d "/run/saagent.pid" ]; then
        rm /run/saagent.pid
fi

cd /usr/local/$ServiceName

if [ ! -d "./$ServiceName" ]; then
       cp ./cagent ./$ServiceName
fi

if [ $DEBUG_MODE == 1 ]; then
  while true; do
        sleep 1
  done
else
   ./$ServiceName
fi

