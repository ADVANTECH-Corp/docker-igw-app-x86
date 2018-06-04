#!/bin/bash

DEF_PATH=/usr/local/EdgeSense
APPS=('HDD_PMQ' 'SUSIControlHandler' 'NodeRed_IoTGateway' 'Modbus_Handler' )
UNINSTALL="uninstall.bash"

for ap in ${APPS[@]}; do
   if [ -f $DEF_PATH/$ap/$UNINSTALL ]; then
   echo "Uninstall EdgeSense service: $ap"
   $DEF_PATH/$ap/$UNINSTALL
   fi
done

   echo "Uninstall all EdgeSense services"

