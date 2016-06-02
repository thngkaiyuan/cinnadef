#!/bin/bash

# Flush everything
iptables -F

# Drop unmatched packets
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Loopback
iptables -A INPUT -i lo -j ACCEPT

# SSH
iptables -A INPUT -i eth0 -p tcp --dport 22 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 22 -m state --state ESTABLISHED -j ACCEPT

# HTTP
iptables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 80 -m state --state ESTABLISHED -j ACCEPT

# HTTPS
iptables -A INPUT -i eth0 -p tcp --dport 443 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -o eth0 -p tcp --sport 443 -m state --state ESTABLISHED -j ACCEPT

# GENERIC FTP
iptables -A INPUT -p tcp --dport 21 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 21 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# ACTIVE FTP
iptables -A OUTPUT -p tcp --sport 20 --dport 1024:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A INPUT -p tcp --dport 20 --sport 1024:65535 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# PASSIVE FTP
iptables -A INPUT -p tcp --dport 1024:65535 --sport 1024:65535 -m conntrack --ctstate NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --sport 1024:65535 --dport 1024:65535 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT

# INBOUND MAILS
iptables -A INPUT -p tcp --match multiport --dports 25,465,587 -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p tcp --match multiport --sports 25,465,587 -m state --state ESTABLISHED -j ACCEPT

# OUTBOUND MAILS
iptables -A OUTPUT -p tcp --match multiport --dports 25,465,587 -j ACCEPT
iptables -A INPUT -p tcp --match multiport --sports 25,465,587 -m state --state ESTABLISHED -j ACCEPT


# FOR LOGGING
iptables -N LOGGING
iptables -A INPUT -j LOGGING
iptables -A OUTPUT -j LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
iptables -A LOGGING -j DROP
