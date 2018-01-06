#!/bin/bash

#read -p "Press [1] to install or [2] to uninstall: " USERINPUT
USERINPUT=1
if [ ${USERINPUT} == "1" ]; then
  rm -rf /usr/lib/libjansson.so* /usr/lib/libSusiIoT.so*
  rm -rf /usr/lib/Advantech/iot
  ldconfig
  mkdir -p /usr/lib/Advantech/iot/modules/
  cp -ra *.so* /usr/lib/
  cp -ra modules/libSUSIDrv.so /usr/lib/Advantech/iot/modules/
  cp -ra modules/libDiskInfo.so /usr/lib/Advantech/iot/modules/
  ldconfig
  echo "install done"
elif [ ${USERINPUT} == "2" ]; then
  rm -rf /usr/lib/libjansson.so* /usr/lib/libSusiIoT.so*
  rm -rf /usr/lib/Advantech/iot
  ldconfig
  echo "uninstall done"
fi

