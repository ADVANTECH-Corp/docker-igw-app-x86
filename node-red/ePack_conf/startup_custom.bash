#!/bin/bash

# Custom Section
INS_DIR=/usr/local/EdgeSense/${PROJECT_NAME}

function install_dependency ()
{
    #apt -y update || exit 1
    #apt -y install npm || exit 1
    apt -y install nodejs
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
    return
}

