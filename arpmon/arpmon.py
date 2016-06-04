#!/usr/bin/env python

import os
import sys
from scapy.all import *

if len(sys.argv) != 2:
	print "Usage: <sudo> ./arpmon.py <subnet e.g. 10.0.0.*>"
	quit()

def active_detect(subnet):
	res = arping(subnet, verbose=False)
	bad_macs = set()
	mac_ips = {}
	for stream in res[0]:
		response = stream[1]
		ip_src = response.sprintf("%ARP.psrc%")
		hw_src = response.sprintf("%ARP.hwsrc%")
		if hw_src not in mac_ips:
			mac_ips[hw_src] = []
		else:
			bad_macs.add(hw_src)
		mac_ips[hw_src].append(ip_src)
	return filter(lambda mac_ip: mac_ip[0] in bad_macs, mac_ips.iteritems())

def passive_scan():
	bad_macs = set()
	mac_ips = {}
	arp_cache = subprocess.check_output('arp -n', shell=True).split("\n")[1::]
	arp_entries = map(lambda line: line.split(), arp_cache)
	for arp_entry in arp_entries:
		if len(arp_entry) < 3:
			continue
		ip, hw_src = arp_entry[0], arp_entry[2]
		if hw_src not in mac_ips:
			mac_ips[hw_src] = []
		else:
			bad_macs.add(hw_src)
		mac_ips[hw_src].append(ip)
	return filter(lambda mac_ip: mac_ip[0] in bad_macs, mac_ips.iteritems())

def output(scan_name, bad_macs):
	print "Results from %s:" % (scan_name)
	for entry in bad_macs:
		bad_mac, ip_set = entry
		print "%s is attemping to spoof as %s" % (bad_mac, ip_set)

# Active detection
bad_macs_active = active_detect(sys.argv[1])

# Passive cache scanning
bad_macs_passive = passive_scan()

if len(bad_macs_active) == 0 and len(bad_macs_passive) == 0:
	print "[ARPMON]: Everything is peaceful here."
else:
	if len(bad_macs_active) > 0:
		output("active scan", bad_macs_active)
	if len(bad_macs_passive) > 0:
		output("passive scan", bad_macs_passive)
