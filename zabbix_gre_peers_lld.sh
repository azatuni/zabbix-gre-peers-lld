#!/bin/bash
#Version: 1.1
#Author: https://github.com/azatuni/zabbix-gre-peers-lld

GRE_INTERFACE_NAME=`echo $@| grep -o 'gre\(\-[a-z]\{1,\}[0-9]\{0,\}\)\{1,2\}'| head -n1`

function get_gre_interfaces_json () {
GRE_INTERFACES=`ip a| grep -o 'gre\(\-[a-z]\{1,\}[0-9]\{0,\}\)\{1,2\}'| sort| uniq`
echo '{'
echo -e '\t"data":['
for gre_interface in $GRE_INTERFACES
do
	if echo $GRE_INTERFACES | grep -vq $gre_interface$
		then ENDLINE=','                                                                                                                                                             
                else ENDLINE=""                                                                                                                                                              
	fi 
	echo -e '\t\t{"{#GRE_INTERFACE}":' \"$gre_interface\"'}'$ENDLINE 
done
echo -e '\t]'                                                                                                                                                                                
echo '}'
}

function get_gre_peer_ip () {
unset GRE_PEER_IP
GRE_PEER_IP=`ip a| grep $GRE_INTERFACE_NAME| grep -o -E "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b"| tail -n1`
}

function get_gre_peer_packet_loss () {
ping -w 2 -W 2 -i 0.2 "$GRE_PEER_IP"|grep -o -e '[0-9]\{1,3\}%'|sed s/%//
}

function get_gre_peer_rtt_avg () {
ping -w 2 -W 2 -i 0.2 "$GRE_PEER_IP"|tail -n1|awk '{print $4}'| cut -d '/' -f2
}

function gre_peers_zabbix_help () {
echo -e "Usage: $0 --key (GRE_INTERFACE)
\t--get-json\t\t\t\tparse all GRE interfaces to json for zabbix low level discovery
\t--get-peer-ip GRE_INTERFACE\tshow GRE interface peer IP address
\t--check-peer-lose GRE_INTERFACE\tcheck ping packet loss to GRE peer in precentage
\t--check-peer-rtt GRE_INTERFACE\tcheck ping average to GRE peer in ms
"
}

case `echo $@| grep -o '\-\-get\-json\|\-\-check\-peer\-lose\|\-\-check\-peer\-rtt\|\-\-get\-peer\-ip\|\-\-help'` in
	--get-json)
		get_gre_interfaces_json
	;;
	--check-peer-lose)
		get_gre_peer_ip
		get_gre_peer_packet_loss
	;;
	--check-peer-rtt)
		get_gre_peer_ip
		get_gre_peer_rtt_avg
	;;
	--get-peer-ip)
		get_gre_peer_ip
		echo "$GRE_PEER_IP"
	;;
	--help)
		gre_peers_zabbix_help	
	;;
esac
