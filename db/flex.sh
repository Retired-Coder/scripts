#============================================
#
# Title: flex.sh
#
# Description: Groups lines per file extension and lists
#              total size in bytes and number of
#              files
#
# Usage: cat <catfile>.. | flex.sh
#
# Parameters:
#               none
#
# Notes: Prints 3 colmns:
#                       extension
#                       size
#                       # of files
#
#============================================
#/bin/bash
awk 'BEGIN { FS = "\t"; OFS = FS }
 	{ n=split($3, ss, "."); if (n > 1) { ext = tolower(ss[n]); e[ext]++; s[ext]+=$4 } }
	END { for (x in e) { print x, s[x], e[x] } }'
