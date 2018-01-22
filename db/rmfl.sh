#============================================
#
# Title: rmfl.sh
#
# Description: rm file
# 
# Usage: cat catfile | rmfl.sh <pre-path>
#
# Parameters:
#		pre-path - path to file location
#
# Notes: Remove the specific file after checking
#	 that it exists
#============================================
#!/bin/bash
#
err=0
#
while read -r line
do 
	fileToRemove=$(echo "$line" | awk -F '\t' '{print $2"/"$3}')
	fileToRemove="$1$fileToRemove"
	if [ -f "$fileToRemove" ]
	then
		rm -v "$fileToRemove"
	else
		let err++
		echo not found: "$fileToRemove"
	fi	
done
if [[ err -gt 0 ]]
then
	echo "error(s): $err"
fi
