#!/bin/sh
#
# Fedora Core 2
# Nick Hemmesch <nick@ndhsoft.com>
# June 2, 2004
#

## Set your IP address
MYIP="YOUR_IP_ADDRESS"
#
## Flush rules & reset counters
iptables -F
iptables -Z
#
## Set policies
iptables -P INPUT DROP
iptables -P FORWARD DROP
iptables -P OUTPUT DROP
#
## Drop all incoming fragments
iptables -A INPUT -i eth0 -f -j DROP
#
## Drop outside packets with local addresses - anti-spoofing measure
iptables -A INPUT -s $MYIP -i ! lo -j DROP
iptables -A INPUT -s 127.0.0.0/8 -i ! lo -j DROP
#iptables -A INPUT -s 10.0.0.0/8 -i ! lo -j DROP
#iptables -A INPUT -s 192.168.0.0/16 -i ! lo -j DROP
iptables -A INPUT -s 224.0.0.0/4 -i ! lo -j DROP
iptables -A INPUT -s 0.0.0.0/8 -i ! lo -j DROP
iptables -A INPUT -s 255.255.255.255 -i ! lo -j DROP
iptables -A INPUT -s 169.254.0.0/16 -i ! lo -j DROP
iptables -A INPUT -s 221.240.102 -i ! lo -j DROP
iptables -A INPUT -s 203.215.94.193 -i ! lo -j DROP
iptables -A INPUT -s 218.71.137.68 -i ! lo -j DROP
#
## Pass all locally-originating packets
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT
#
## Accept ICMP ping echo requests
## (this allows other people to ping your machine, among other things),
iptables -A INPUT -p icmp --icmp-type echo-request -j ACCEPT
#
## Accept all traffic from a specific machine with IP x.x.x.x
## replace x.x.x.x with the desired IP, then uncomment the line.
#iptables -A INPUT -p tcp -m tcp --syn -s xxx.xxx.xxx.xxx -j ACCEPT
#
## Accept traffic on port p from a specific machine with IP x.x.x.x
## replace p with the desired port number, and replace x.x.x.x with
## the desired IP, then uncomment the line.
#iptables -A INPUT -p tcp -m tcp --syn -s x.x.x.x --dport p -j ACCEPT
#
## Accept ftp-data and ftp (ports 20 & 21)
iptables -A INPUT -p tcp -m tcp --syn --dport 20 -j ACCEPT
iptables -A INPUT -p tcp -m tcp --syn --dport 21 -j ACCEPT
#
## Accept ssh (port 22)
iptables -A INPUT -p tcp -m tcp --syn --dport 22 -j ACCEPT
#
## Accept telnet (port 23)
#iptables -A INPUT -p tcp -m tcp --syn --dport 23 -j ACCEPT
#
## Accept smtp (port 25)
iptables -A INPUT -p tcp -m tcp --syn --dport 25 -j ACCEPT
#
## Accept dns (port 53)
iptables -A INPUT -p udp -m udp -s 0/0 --dport 53 -d 0/0 -j ACCEPT
iptables -A INPUT -p tcp -m tcp -s 0/0 --dport 53 -d 0/0 -j ACCEPT
#
## Accept http (port 80)
iptables -A INPUT -p tcp -m tcp --syn --dport 80 -j ACCEPT
#
## Accept pop3 (port 110)
iptables -A INPUT -p tcp -m tcp --syn --dport 110 -j ACCEPT
#
## Accept inbound identd (port 113)
iptables -A INPUT -p tcp -m tcp --syn --dport 113 -j ACCEPT
## or you can reject and send back a TCP RST packet instead
#iptables -A INPUT -p tcp -m tcp --dport 113 -j REJECT --reject-with tcp-reset
#
## Accept imap (port 143)
iptables -A INPUT -p tcp -m tcp --syn --dport 143 -j ACCEPT
#
## Accept https (port 443)
iptables -A INPUT -p tcp -m tcp --syn --dport 443 -j ACCEPT
#
## Accept smtps (port 465)
iptables -A INPUT -p tcp -m tcp --syn --dport 465 -j ACCEPT
## Accept msp (port 587)
iptables -A INPUT -p tcp -m tcp --syn --dport 587 -j ACCEPT
#
## Accept SpamAssassin (port 783)
#iptables -A INPUT -p tcp -m tcp --syn --dport 783 -j ACCEPT
#
## Accept imaps (port 993)
iptables -A INPUT -p tcp -m tcp --syn --dport 993 -j ACCEPT
#
## Accept pop3s (port 995)
iptables -A INPUT -p tcp -m tcp --syn --dport 995 -j ACCEPT
#
## Accept mysql (port 3306)
#iptables -A INPUT -p tcp -m tcp --syn --dport 3306 -j ACCEPT
#
## Allow inbound established and related outside communication
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
#
## Drop outside initiated connections
iptables -A INPUT -m state --state NEW -j REJECT
#
## Allow all outbound tcp, udp, icmp traffic with state
iptables -A OUTPUT -p tcp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p udp -m state --state NEW,ESTABLISHED -j ACCEPT
iptables -A OUTPUT -p icmp -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
#
## Save rules
service iptables save
#
#
echo "iptables configuration is complete"
echo ""
echo "Check your rules - iptables -L -n"
echo ""


