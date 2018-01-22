#!/bin/bash
#============================================
#
# Title: dbl.sh 
#
# Description: Find doubles based on md5 checksum 
# 
# Usage: cat <catfile>.. | dbl.sh 
#
# Parameters:
#	 	none	
#
# Notes: Order of files is important. Only shows
# 	 lines of which the checksum is known.
#	 It will only find the second or next
#	 checksum match. 
#	 
#	 Prints all 7 columns
#
#============================================
#
awk 'BEGIN { FS = "\t" } { if (seen[$7]++) print }'
