#!/bin/bash

# Function for displaying logo1
logo1() {
clear
echo ""
echo -e "                       ██╗    ██╗██╗███████╗██╗                 "    
echo -e "                       ██║    ██║██║██╔════╝██║                 " 
echo -e "                       ██║ █╗ ██║██║█████╗  ██║                 "
echo -e "                       ██║███╗██║██║██╔══╝  ██║                 "
echo -e "                       ╚███╔███╔╝██║██║     ██║                 "
echo -e "                        ╚══╝╚══╝ ╚═╝╚═╝     ╚═╝                 "                          
echo -e "               ███████╗██╗   ██╗████████╗███████╗██████╗        "
echo -e "               ██╔════╝██║   ██║╚══██╔══╝██╔════╝██╔══██╗       "
echo -e "               █████╗  ██║   ██║   ██║   █████╗  ██████╔╝       "
echo -e "               ██╔══╝  ██║   ██║   ██║   ██╔══╝  ██╔══██╗       "
echo -e "               ███████╗╚██████╔╝   ██║   ███████╗██║  ██║       "
echo -e "               ╚══════╝ ╚═════╝    ╚═╝   ╚══════╝╚═╝  ╚═╝       "
echo ""
echo "              CODED BY: JAYSON CABRILLAS SAN BUENAVENTURA"
echo ""
echo ""
}

# Check if running as root.
super_user() {
  if [[ "$EUID" -ne 0 ]]; then
    clear
    echo " [!] WIFI-EUTER" | figlet -f slant
    echo " ERROR!!! This script must be run as root." >
    exit 1
  fi
}

# Dependencies
chk_dep () {
	clear
	logo1
	if [[ -f "dependencies.conf" ]]; then
		sleep 1
	else
		echo " [!]Checking Dependecies .........."
		echo ""
		touch dependencies.conf
		echo "# 4WSec Just Dropped Yo Wireless" >> dependencies.conf
		sleep 1

		# Checking MDK3
		which mdk3 > /dev/null 2>&1
		if [[ $? -eq 0 ]]; then
			echo " MDK3 .......... [✔]"
			echo "mdk3 = yes" >> dependencies.conf
		else
			echo " MDK3 .......... ✘]"
			sleep 1
			apt install mdk3 -y
		fi

		# Checking Network Manager
		which nmcli > /dev/null 2>&1
		if [[ $? -eq 0 ]]; then
			echo " Network Manager .......... [✔]"
			echo "nmcli = yes" >> dependencies.conf
		else
			echo " Network Manager .......... ✘]"
			sleep 1
			apt install network-manager -y
		fi

		# Checking MAC Changer
		which macchanger > /dev/null 2>&1
		if [[ $? -eq 0 ]]; then
			echo " MAC Changer .......... [✔]\n"
			echo "macchanger = yes" >> dependencies.conf
		else
			echo " MAC Changer .......... ✘]"
			sleep 1
			apt install macchanger -y
		fi
		sleep 5		
	fi
}

super_user
chk_dep
echo " [✔] All weapons are ready!"
