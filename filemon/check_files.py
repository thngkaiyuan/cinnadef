#!/usr/bin/env python

from __future__ import with_statement
import base64
import time
import datetime
from monitor_files import FLAG_FILE, get_file_info

LOG_FILE = './tamper_log'

def log_restore(filepath):
	ts = time.time()
	now = datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')
	prefix = '[' + now + ']: '
	message = "Someone messed with " + filepath
	log_entry = prefix + message
	with open(LOG_FILE, 'a') as log_file:
		log_file.write(log_entry + "\n")
	print log_entry

def restore_backup(filepath, encoding):
	with open(filepath, 'w') as f:
		orig_contents = base64.b64decode(encoding)
		f.write(orig_contents)
	log_restore(filepath)

with open(FLAG_FILE, 'r') as flag_file:
	filepath_hash_encoding_list = flag_file.readlines()

for filepath_hash_encoding in filepath_hash_encoding_list:
	filepath, orig_hash, orig_encoding = filepath_hash_encoding.split(':')
	curr_hash, curr_encoding = get_file_info(filepath)
	if curr_hash != orig_hash:
		restore_backup(filepath, orig_encoding)


