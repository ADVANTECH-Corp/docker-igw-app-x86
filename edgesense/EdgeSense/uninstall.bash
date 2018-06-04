#!/bin/bash
PROJECT_NAME=EdgeSense
INS_DIR=/usr/local/EdgeSense/${PROJECT_NAME}
DEF_PATH=/usr/local/EdgeSense
APPS=('HDD_PMQ' 'SUSIControlHandler' 'NodeRed_IoTGateway' 'Modbus_Handler' )
UNINSTALL="uninstall.bash"

function remove_service ()
{

   for ap in ${APPS[@]}; do
     if [ -f $DEF_PATH/$ap/$UNINSTALL ]; then
     echo "Uninstall EdgeSense service: $ap"
     $DEF_PATH/$ap/$UNINSTALL
     fi
   done

   echo "Uninstall all EdgeSense services"
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
