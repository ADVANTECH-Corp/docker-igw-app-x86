#!/bin/bash
#EPACK_PATH=/home/eric/Work/EdgeSense/Docker-less/dev/Modbus_Handler/ePack
EPACK_PATH=../../ePack
source ePack_custom.bash

if [ -z "${EPACK_PATH}" ]; then
    echo "Please define ePack path"
    exit 1
fi

echo "PROJECT NAME is $PROJECT_NAME"

echo "clean last data in ePack"
rm -rf ${EPACK_PATH}/archive

mkdir -p ${EPACK_PATH}/archive/rootfs/usr/local/EdgeSense/$PROJECT_NAME || exit 1
mkdir -p ${EPACK_PATH}/archive/rootfs/etc/systemd/system || exit 1
rm -rf  ${EPACK_PATH}/archive/rootfs/usr/local/EdgeSense/$PROJECT_NAME/* || exit 1

# Package Info
cp -f ePack_custom.bash ${EPACK_PATH}/archive/rootfs/usr/local/EdgeSense/${PROJECT_NAME}/package.info || exit 1
# All data
cp -rf ../${PROJECT_NAME}/* ${EPACK_PATH}/archive/rootfs/usr/local/EdgeSense/$PROJECT_NAME || exit 1

#tmp
cp -rf ../tmp/* ${EPACK_PATH}/archive || exit 1

cp -f ePack_custom.bash ${EPACK_PATH}/archive || exit 1
cp -f startup_custom.bash ${EPACK_PATH}/archive || exit 1

#make install DESTDIR=${EPACK_PATH}/archive/rootfs || exit 1

cd ${EPACK_PATH} || exit 1
./build.bash
