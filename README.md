# zabbix-lld-for-linux-gre
Zabbix Low Level Discovery (LLD) for linux GRE peers monitoring. 
# About
Bash script that automatically discovers GRE interfaces and monitor peers via calculating ICMP ping packet loss and route trip time (RTT).<br>
For ping zabbix_gre_peers_lld.sh script takes two parameters(variables): GRE_PEER_PING_INTERVAL and GRE_PEER_PING_TIMEOUT, declared in zabbix_gre_peers_lld_ping.conf file. Ping packets count depends on those two variables. For example if GRE_PEER_PING_INTERVAL is set to 0.2 s. (minimum for not root users) and GRE_PEER_PING_TIMEOUT is set to 2, then whole ping process will take 2s and ping packets count will be 10 (GRE_PEER_PING_TIMEOUT / GRE_PEER_PING_INTERVAL). If you need to increase packets count please increase zabbix-agent timeout on GRE host (TIMEOUT parameter on zabbix_agentd.conf file), also possibly you will need to increase zabbix-agent child processes count (StartAgents parameter on zabbix_agentd.conf file), so ping will not "eat" all zabbix-agent child processes and wouldn't have impact on zabbix-agent performance.
# Installation
