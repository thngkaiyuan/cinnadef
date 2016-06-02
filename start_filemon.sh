#!/bin/bash

while true
do
	(cd filemon && exec ./check_files.py)
	sleep 0.25
done

