#/bin/bash
#============================================
#
# Title: dskgrp.sh
#
# Description: Groups lines per catalog and lists
#	       total size in bytes and number of
#	       files
# 
# Usage: cat <catfile>|<dircat>.. | dskgrp.sh
#
# Parameters:
#		none
#
# Notes: Prints 3 colmns:
#			catalog
#			size
#			# of files
#
#============================================
#
awk 'BEGIN { FS = "\t"; OFS = FS }
	{ if( NF == 4) {cnt[$1]+=$4; size[$1]+=$3} else {cnt[$1]++; size[$1]+=$4} }
	END {for(i in cnt) { print i, size[i], cnt[i] } }'
