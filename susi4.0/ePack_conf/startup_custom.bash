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
    cd ${TOPDIR} || exit 1

    INSTALLER="susi4.0_driver"
    	
    # install susi driver
    if [ -d "${INSTALLER}" ]; then	
        cd ${INSTALLER}/susiinstaller/SUSI4.0/Driver
        ./install.sh 
    else
	echo "[Error] Can not install SUSI Driver!" 
        exit 1
    fi 

    cd ${TOPDIR} || exit 1
	
    # install susiiot 
    if [ -d "${INSTALLER}" ]; then
        cd ${INSTALLER}/susiinstaller/SUSIIoT/library
        ./install.sh 1
    else
        echo "[Error] Can not install SUSIIoT Driver!"
        exit 1
    fi
    
    return
}

