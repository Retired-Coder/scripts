#!/bin/bash
#============================================
#
# Title: dblfl.sh 
#
# Descripton: Find matching files for one catfile 
# 
# Usage: dblfl.sh <catfile> <catfile..>
#
# Parameters:
#		<catfile> - catfile base
#		<catfile..> - catfile(s) to match
#
# Notes: 
#	Ignores same lines in base and match
#	
#	Returns
#		All columns
#
#============================================
#
awk 'BEGIN {FS = "\t"; OFS = FS} 
	{if(FNR==NR) {base[($7)]++; line[$0]++; next} 
	{if(base[$7] && !($0 in line)) {base[$7]++; print $0}
	}} END {for(i in line) {n=split(i,str, FS); if(base[str[n]] > 1) print i}}' "$1" "$2"
