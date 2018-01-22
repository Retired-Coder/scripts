#!/bin/bash
#============================================
#
# Title: dbldir.sh 
#
# Descripton: Find matching dirs for one dircat 
# 
# Usage: dbldir.sh <dircat> <dircat..>
#
# Parameters:
#		<dircat> - dircat base
#		<dircat..> - dircat(s) to match
#
# Notes: Returns
#		Catalog
#		Dir
#		Size
#		# of files
#
#============================================
#
awk 'BEGIN {FS = "\t"; OFS = FS} 
	{if(FNR==NR) {dirs[tolower($2)]+=$3; cnt[tolower($2)]+=$4; next} 
	{if(tolower($2) in dirs) 
		{print $1, $2, dirs[tolower($2)], cnt[tolower($2)]} 
	}}' "$1" "$2"
