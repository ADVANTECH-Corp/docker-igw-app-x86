#!/bin/bash

ServiceName=EService-HDDPMQ

if [ ! -d "/home/adv/$ServiceName" ]; then
        mkdir /home/adv/$ServiceName
        mkdir /home/adv/$ServiceName/config
        cp /usr/local/$ServiceName/agent_config.xml /home/adv/$ServiceName/config/.        
fi


if [ ! -d "/home/adv/$ServiceName/config/agent_config.xml" ]; then
        cp /home/adv/$ServiceName/config/agent_config.xml /usr/local/$ServiceName/.
fi

cd /usr/local/$ServiceName

./cagent
