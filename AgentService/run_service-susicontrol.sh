#!/bin/bash

if [ ! -d "/home/adv/SUSIControl" ]; then
        mkdir /home/adv/SUSIControl
        mkdir /home/adv/SUSIControl/config
        cp /usr/local/AgentService/agent_config.xml /home/adv/SUSIControl/config/.
fi


if [ ! -d "/home/adv/SUSIControl/config/agent_config.xml" ]; then
        cp /home/adv/SUSIControl/config/agent_config.xml /usr/local/AgentService/.
fi

cd /usr/local/AgentService

./cagent
