#!/bin/bash
#============================================
#
# Title: sana.sh
#
# Description: Finds duplicate directory and filename
# 
# Usage: cat <catfile>.. | sana.sh
#
# Parameters:
#		none
#
# Notes: Prints all 7 columns
#
#============================================
#
awk 'BEGIN { FS = "\t" } { if (seen[tolower($2$3)]++) print }'
