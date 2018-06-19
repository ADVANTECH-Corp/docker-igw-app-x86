#!/bin/bash
#
# Program:
#	This script installs the packages on your computer
#
# Release Date:
#	2018/02/22
# 
# Copyright (c) Advantech Co., Ltd. All Rights Reserved
package_name="EdgeSense (Ubuntu 16.04 x64)"
version=1.0.1
current_dir="$(pwd)/"
cloud_selection=0
function RootCheck(){
	if [ "$EUID" -ne 0 ]
		then echo "Please run as root"
		NewLine 1
		exit 1
	fi
}
function WelcomeMessage(){
	clear
	echo "---------------------------------------------------------------------------"
	echo ""
	echo "Welcome to the $package_name version:$version Setup"
	echo ""
	echo "The Setup will install necessary agent and documentation on your computer "
	echo "based on the cloud you choose to connect to."
	echo ""
	echo "Please refer to readme.txt for the reqirement of installation and how to"
	echo "install."
	echo ""
	echo "---------------------------------------------------------------------------"
	read -p "Press ENTER to continue"
}
function FinishedMessage(){
	echo ""
	echo "---------------------------------------------------------------------------"
	echo "Installation is completed. "
	echo ""
	echo "# Before getting connected, refer to readme.txt for more info."
        read -p "# Would you like to launch the readme.txt now? (Y)es (N)o: " choice
	
	case $choice in 
	  [Yy])
	        clear
	        more introduction.txt
		;;
	  *)
		;;
	esac
	
	NewLine 5
}
function EULA(){
	clear
	echo "---------------------------------------------------------------------------"
	echo ""
	echo "PLEASE READ AND ACCEPT THE END-USER LICENSE AGREEMENT(EULA) "
	echo "BEFORE USING THE SOFTWARE."
	echo ""
	echo "---------------------------------------------------------------------------"
	echo "Do you agree with the terms of EULA?"
	echo "(Y)es"
	echo "(N)o"
	echo "(R)ead the EULA"	
	read -p "" choice
	
	case $choice in 
	  [Yy])
		;;
	  [Nn])
		NewLine 1
	        exit 1
		;;
	  [Rr])
		more ./eula/EULA*.txt
		NewLine 1
		read -p "Press ENTER to continue"
		EULA
		;;
	  *)
		clear
		EULA
		;;
	esac
}
function CloudSection(){
	clear
	echo "---------------------------------------------------------------------------"
	echo ""
	echo "CLOUD SELECTION"
	echo ""
	echo "---------------------------------------------------------------------------"
	echo "Please choose the cloud that you'd like to connect to:"
	echo "(1) WISE-PaaS/EdgeSense (device management service developed on WISE-PaaS/EnSaaS )"
	echo "(2) Microsoft Azure"
	echo "(3) Amazon Web Services (AWS)"
	read -p "" choice
	
	case $choice in 
	  [1])
	    echo "You should download and install the latest RMM-Agent from WISE-PaaS/EdgeSense protoal"
            NewLine 1
            read -p "Press ENTER to continue"
	    InstallPlugins
		;;
	  [2])
            echo "You should download the Azure Node-RED flow from Online help"
            NewLine 1
            read -p "Press ENTER to continue"
	    InstallPlugins
		;;        
	  [3])
	    InstallAWS
	    InstallPlugins
		;;
	  *)
		read -p "Invalid choice. Please select again."
		clear
		CloudSection
		;;
	esac
}

function install_service() {

   cd ${current_dir} || exito ""1
   if [ -f ./$1 ]; then
      ./$1 -- -s || exit 1
   fi
}

function InstallPlugins(){
	
	echo "---------------------------------------------------------------------------"
	echo ""
	echo "INSTALLING PLUG-INS"
	echo ""
	echo "---------------------------------------------------------------------------"
        APPS=("MQTTBrokerSetup-1.0.3-Ubuntu_16.04-x86_64.run" "SUSI4.0_Driver-1.0.14788-Ubuntu_16.04-x86_64.run" "HDD_PMQ-1.0.2-Ubuntu_16.04-x86_64.run" "Modbus_Handler-1.0.2-Ubuntu_16.04-x86_64.run" "NodeRed_IoTGateway-2.0.1-Ubuntu_16.04-x86_64.run")
        
	for ap in ${APPS[@]}; do
          install_service $ap
	done
}
function InstallAWS(){
	echo "---------------------------------------------------------------------------"
	echo ""
	echo "INSTALLING ESSENTIALS FOR AWS"
	echo ""
	echo "---------------------------------------------------------------------------"
        cd ${TOPDIR} || exit 1
        installer="AWS_GG-1.0.2-Ubuntu_16.04-x86_64.run"
        install_service $installer
}
function NewLine(){
	for i in $(seq 1 $1)
		do
			echo ""
		done
}
# Main code
cd ${current_dir} 
RootCheck
WelcomeMessage
EULA
CloudSection
FinishedMessage
