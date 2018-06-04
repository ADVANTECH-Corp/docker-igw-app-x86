#!/bin/bash
PROJECT_NAME=SUSI4.0_Driver
INS_DIR=/usr/local/EdgeSense/${PROJECT_NAME}

function remove_service ()
{
    if [ ! -z "${PROJECT_NAME}" ] && [ ! -z "${INS_DIR}" ]; then
       # remove susi
       cd ${INS_DIR}/SUSI4.0
       ./install.sh u
       # remove susiiot
       cd ${INS_DIR}/SUSIIoT
       ./install.sh 2
    fi
    return
}

function remove_project ()
{
    if [ ! -z "${PROJECT_NAME}" ] && [ ! -z "${INS_DIR}" ]; then
        rm -rf --preserve-root ${INS_DIR} || exit 1
    fi
}

function remove_others ()
{
    return
}

echo "uninstall ${PROJECT_NAME} ..."
remove_service
remove_project
remove_others
echo "uninstall ${PROJECT_NAME} ... done"
