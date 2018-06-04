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
    # to run install.sh after coping the installer 
    cd ${INS_DIR} || exit 1

    INSTALLER="EISXGGC1.0.2.tar.gz"
    	
    # install susi driver
    if [ -f "${INSTALLER}" ]; then	
        tar xf *.tar.gz
        cd EISXGGC
        ./install.sh 
    else
	echo "[Error] Can not install AWS GG!" 
        exit 1
    fi 

    return
}

