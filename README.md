# zabbix-lld-for-linux-gre
Zabbix Low Level Discovery (LLD) for linux GRE peers monitoring. 
# About
  Bash script that automatically discovers GRE interfaces and monitor peers via calculating ICMP ping packet loss and route trip time (RTT).
  For ping zabbix_gre_peers_lld.sh script takes two parameters(variables): `GRE_PEER_PING_INTERVAL` and `GRE_PEER_PING_TIMEOUT`, declared in zabbix_gre_peers_lld_ping.conf file. Ping packets count depends on those two variables. For example if GRE_PEER_PING_INTERVAL is set to 0.2 (0.2 s minimum ping interval for not root users) and GRE_PEER_PING_TIMEOUT is set to 2, then whole ping process will take 2s and ping packets count will be 10 (GRE_PEER_PING_TIMEOUT / GRE_PEER_PING_INTERVAL). If you need to increase packets count please increase zabbix-agent timeout on GRE host (`TIMEOUT` parameter on `zabbix_agentd.conf` file), also possibly you will need to increase zabbix-agent child processes count (`StartAgents` parameter on `zabbix_agentd.conf` file), so ping will not "eat" all zabbix-agent child processes and wouldn't have impact on zabbix-agent performance.
# Installation
1. Download or make a git clone on GRE peer server<br>
  `wget https://github.com/azatuni/zabbix-gre-peers-lld/archive/master.zip && unzip master.zip`
  or
  `git clone https://github.com/azatuni/zabbix-gre-peers-lld.git`
2. Move to zabbix_gre_peers_lld
  `cd zabbix_gre_peers_lld`
3. Make a /usr/local/scripts directory
  `mkdir -p /usr/local/scripts`
4. Copy script and config file example to /usr/local/scripts
  `cp zabbix_gre_peers_lld.sh /usr/local/scripts && zabbix_gre_peers_lld_ping.conf.example /usr/local/scripts/zabbix_gre_peers_lld_ping.conf`
5.  Copy zabbix-agent custom items to zabbix-agent include directory (Usually /etc/zabbix/zabbix_agentd.d/)
  `cp zabbix_gre_peers_lld.conf /etc/zabbix/zabbix_agentd.d/`
6.  Restart zabbix-agent
  `service zabbix-agent restart`
7.  Run a script for test and it'd return json object with gre interfaces
    `/usr/local/scripts/zabbix_gre_peers_lld.sh --get-json  `
8.  Import zabbix_gre_peers_lld.xml template to zabbix UI (Configuration > Templates > Import)
9.  Attache "Template Linux GRE peers" template to GRE host
