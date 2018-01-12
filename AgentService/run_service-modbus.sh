#!/bin/bash

ServiceName=EService-Modbus

if [ ! -d "/home/adv/$ServiceName" ]; then
        mkdir /home/adv/$ServiceName
        mkdir /home/adv/$ServiceName/config
        cp /usr/local/$ServiceName/agent_config.xml /home/adv/$ServiceName/config/.        
        cp /usr/local/$ServiceName/Modbus_Handler.ini /home/adv/$ServiceName/config/.
fi


if [ ! -d "/home/adv/$ServiceName/config/agent_config.xml" ]; then
        cp /home/adv/$ServiceName/config/agent_config.xml /usr/local/$ServiceName/.
fi

if [ ! -d "/home/adv/$ServiceName/config/Modbus_Handler.ini" ]; then
        cp /home/adv/$ServiceName/config/Modbus_Handler.ini /usr/local/$ServiceName/.
fi

if [ ! -d "/run/saagent.pid" ]; then
        rm /run/saagent.pid
fi

cd /usr/local/$ServiceName

./cagent
