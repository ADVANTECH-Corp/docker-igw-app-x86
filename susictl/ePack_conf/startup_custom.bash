#!/bin/bash

# Custom Section
INS_DIR=/usr/local/EdgeSense/${PROJECT_NAME}

function install_dependency ()
{
    sudo apt -y install net-tools iputils-ping libssl-dev gawk sed libxml2 libmosquitto1 sqlite3
    # install susi driver

    # install susiiot

  
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

