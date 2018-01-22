#!/bin/bash
#============================================
#
# Title: uniqdir.sh
#
# Description: Lists only unique directories
# 
# Usage: cat <catfile>.. | uniqdir.sh
#
# Parameters:
#		none
#
# Notes: Order of catfiles is important. Only
#	 unseen values will be printed, so
#	 put the catalog to inspect last
#	 in line. 
#	 Print 2 columns:
#			catalog
#			directory
#
#============================================
#
awk 'BEGIN { FS = "\t"; OFS = FS } { if (!seen[tolower($2)]++) print $1, $2}'
