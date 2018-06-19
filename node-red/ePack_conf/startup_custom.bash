#!/bin/bash

# Custom Section
INS_DIR=/usr/local/EdgeSense/${PROJECT_NAME}
NODE_RED_DIR1=/usr/local/lib/node_modules/node-red/
NODE_RED_DIR2=/usr/lib/node_modules/node-red/

function install_dependency ()
{
    #apt -y update || exit 1
    #apt -y install npm || exit 1
    #apt -y install nodejs-legacy || exit 1
    apt -y install nodejs || exit 1
    apt -y install npm
    ln -s /usr/bin/nodejs /usr/bin/node  
    npm install -g --unsafe-perm node-red
    return
}

function backup_config ()
{
    return
}

function restore_config ()
{
    return
}

function install_others ()
{

    cd ${TOPDIR} || exit 1

    # install susiiot
    if [ -d "${NODE_RED_DIR1}" ]; then
        cp NodeRed_IoTGateway1.service /etc/systemd/system/${PROJECT_NAME}.service
        cp -r ${INS_DIR}/node_modules ${NODE_RED_DIR1}/
    fi
  
    if [ -d "${NODE_RED_DIR2}" ]; then
	cp NodeRed_IoTGateway2.service /etc/systemd/system/${PROJECT_NAME}.service
        cp -r ${INS_DIR}/node_modules ${NODE_RED_DIR2}/
    fi

    chmod 664 /etc/systemd/system/"${PROJECT_NAME}.service" || exit 1
    return
}

