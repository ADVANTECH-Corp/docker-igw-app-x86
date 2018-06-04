#!/bin/bash

# Custom Section
INS_DIR=/usr/local/EdgeSense/${PROJECT_NAME}

function install_dependency ()
{
  
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
    ./install.sh
    return
}

