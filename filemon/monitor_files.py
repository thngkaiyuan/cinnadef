#!/usr/bin/env python

from __future__ import with_statement
import os
import sys
import hashlib
import base64

FLAG_FILE = './monitored_files'

def get_file_info(filepath):
	md5_hash = hashlib.md5()
	with open(filepath, 'rb') as f:
		contents = f.read()
		md5_hash.update(contents)
	return md5_hash.hexdigest(), base64.b64encode(contents)

def monitor_file(filepath):
	with open(FLAG_FILE, 'a') as flag_file:
		hash, encoding = get_file_info(filepath)
		line = ':'.join((filepath, hash, encoding))
		flag_file.write(line + "\n")

num_files = len(sys.argv) - 1
for i in range(1,num_files + 1):
	filepath = os.path.realpath(sys.argv[i])
	monitor_file(filepath)

