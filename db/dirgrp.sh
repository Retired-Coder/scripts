#/bin/bash
#============================================
#
# Title: dirgrp.sh
#
# Description: Groups line per directory
#	       and lists size in bytes and 
# 	       number of files
# 
# Usage: cat <catfile>.. | dirgrp.sh 
#
# Parameters:
#		none
#
# Notes: prints 4 columns:
#			 catalog
#			 directory
#			 size
#			 # of files
#
#============================================
awk 'BEGIN { FS = "\t"; OFS = FS }
	{ cnt[$1 FS $2]++; size[$1 FS $2]+=$4 }
	END {for(i in cnt) { print i, size[i], cnt[i] } }'
