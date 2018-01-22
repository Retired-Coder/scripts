#!/bin/bash
#============================================
#
# Title: nice.sh
#
# Description: Format output of cat file
# 
# Usage: cat catfile.. | nice.sh
#
# Parameters:
#		none
#
# Notes: 
#	Output is based on number of columns
#	provided. Use last in a chain of pipes.
#	
#============================================
#
awk 'BEGIN { FS = "\t"; maxlenDirNF7 = 20; maxlenFileNF7 = 70; maxlenDirNF4 = 80;
		eCLR = "\033[100m"; oCLR = "\033[0m"; rCLR = oCLR;
		formatNF3 = "%-10s|%9s|%8s" rCLR "\n";
		formatNF4 = "%-10s|%-" maxlenDirNF4 "s|%9s|%8d" rCLR "\n";
		formatNF7 = "%-10s|%-" maxlenDirNF7 "s|%-" maxlenFileNF7 "s|%9s|%8s|%8s|%32s" rCLR "\n";
		tsize = 0; tcount = 0}
	function humsize(num) {
		result = ""; hum[1024*1024*1024]="Gb"; hum[1024*1024]="Mb"; hum[1024]="Kb";
 		if (length(num) > 0 && num<1024)
			{ result = num "b" }
		else
			{ for (x=1024*1024*1024; x>=1024; x/=1024){
			        if (num>=x) { result = num/x hum[x];break }} }
		return result } {
	if ( NR == 1) { print "-- " NF " Columns" }
	if ( NR % 2 == 0) {CLR = eCLR} else {CLR = oCLR}
	if (NF == 2) { print CLR $1" | "$2 rCLR }
	else if (NF == 3) {
		tsize += $2; tcount += $3;
		printf(CLR formatNF3, $1, humsize($2), $3) }
	else if (NF == 4) {
		tsize += $3; tcount += $4;
		if (length($2) > maxlenDirNF4) {$2 = substr($2,1,10)"..."substr($2,1+length($2)-(maxlenDirNF4-13))}
		printf(CLR formatNF4, $1, $2, humsize($3), $4) }
	else if (NF == 7) {
		tsize += $4;
		if (length($2) > maxlenDirNF7) {$2 = substr($2,1,10)"..."substr($2,1+length($2)-(maxlenDirNF7-13))}
		if (length($3) > maxlenFileNF7) {$3 = substr($3,1,10)"..."substr($3,1+length($3)-(maxlenFileNF7-13))}
		printf(CLR formatNF7, $1, $2, $3, humsize($4), $5, $6, $7) }
	else	{ print $0 }
	} END { printf "-- " NR " Record(s)"; if (NR>1 && tsize>0) {printf " - " humsize(tsize)}; if(NR>1 && tcount>0) {printf " - " tcount}; {printf "\n"}}'
#
# beep when done
#
echo -en "\007"
