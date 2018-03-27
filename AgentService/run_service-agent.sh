#!/bin/bash

ServiceName=AgentService

if [ ! -d "/home/adv/$ServiceName" ]; then
        mkdir /home/adv/$ServiceName
        mkdir /home/adv/$ServiceName/config
        cp /usr/local/$ServiceName/agent_config.xml /home/adv/$ServiceName/config/.        
        cp /usr/local/$ServiceName/module/module_config.xml /home/adv/$ServiceName/config/.
fi


if [ ! -d "/home/adv/$ServiceName/config/agent_config.xml" ]; then
        cp /home/adv/$ServiceName/config/agent_config.xml /usr/local/$ServiceName/.
fi

if [ ! -d "/home/adv/$ServiceName/config/module_config.xml" ]; then
        cp /home/adv/$ServiceName/config/agent_config.xml /usr/local/$ServiceName/module/.
fi

if [ ! -d "/run/saagent.pid" ]; then
        rm /run/saagent.pid
fi


cd /usr/local/$ServiceName

cp /usr/local/$ServiceName/agent_config.xml /home/adv/$ServiceName/config/.


if [ $DEBUG_MODE == 1 ]; then
  while true; do
        sleep 1
  done
else
   ./cagent
fi


