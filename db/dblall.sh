#!/bin/bash
#============================================
#
# Title: dblall.sh 
#
# Description: Finds all doubles based on md5 checksum
# 
# Usage: cat <catfile>.. | dblall.sh
#
# Parameters:
#		none
#
# Notes: Prints all 7 columns
#
#============================================
#
awk 'BEGIN { FS = "\t" } { sn[$7]++; ln[$0] } 
	END { for (i in ln) { n=split(i,ia, FS); if(sn[ia[n]] > 1) {print i} } }'
