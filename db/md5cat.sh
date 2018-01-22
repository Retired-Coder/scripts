#!/bin/bash
#============================================
#
# Title: md5cat.sh 
#
# Description: index files with md5 checksum 
# 
# Usage: md5cat.sh <sourcedir> <targetfile> [dir] 
#
# Parameters:
#		sourcedir - directory to index
#		targetfile - file with index results,
#				the catalog
#		[dir] - directory mask to include
#
# Notes: produces a file with file info per line
#	 columns are seperated with TABs
#	 Columns are:
#		1. Catalog name - same name as targetfile
#		2. Directorypath - relative path to file
#		3. Filename - Name of the file
# 		4. Filesize - in bytes
#		5. Filedate - modification date
#		6. Filetime - modification time
#		7. Checksum - md5 checksum 
#
#============================================
#
if [ ! "$#" -ge 2 ]; then
  echo "Syntax: "$0" <sourcedir> <targetfile> [dir]"
  exit
fi
#
if [ ! -d "$1" ]; then
  echo directory "$1" not found
  # No sourcedir, exit here
  exit
fi
#
tardir=$(dirname "$2")
if [ ! -d "$tardir" ]; then
  echo directory "$tardir" not found
  # No targetdir, exit here
  exit
fi
#
if  [ -z "$3" ]; then
  dir=*
else
  dir=$3
fi
#
dsk=$(basename "$2")
pfx=".old"
new=0
exist=0
teller=0
findcmd=$(echo find "$dir" -type f -printf "$dsk"'\t%h\t%f\t%s\t%TY-%Tm-%Td\t%TT\n')
#
# Note: %TT includes 11 chars not usefull
#
pushd "$1" > /dev/null 2>&1
findrslt=$($findcmd)
popd > /dev/null 2>&1
#
cntrslt=$(echo "$findrslt" | wc -l)
#
if [ -z "$findrslt" ]; then
  echo no files found
  # Make existing file empty or create new one
  $(> "$2")
  exit
fi
#
SAVEIFS=$IFS
IFS=$(echo -en "\n\b")
if [ ! -f "$2" ]; then
  # Target file does not exists, create a new one
  touch "$2"
else
  # Target file exists, only index new and changed files
  mv "$2" "$2$pfx"
  file_exist=1
  touch "$2"
fi
#
for s in $findrslt
  do
  #
  # show progress
  #
  let "teller++"
  prev_pgs=$pgs
  pgs=$(($teller*100/$cntrslt))
  if (( ($new+$exist) % 10 == 0 )) || (( $prev_pgs != $pgs )); then
    echo -n -e "$dsk" added:"$new" equal:"$exist" complete:"$pgs"% '\r'
  fi
  #
  # Delete last part of the string
  #
  s=${s:0:${#s}-11}
  #
  if [ ! -z "$file_exist" ]; then
	line=$(grep -F -m 1 "$s" "$2$pfx")
    if [ "$line" ]; then
	  echo "$line" >> "$2"
	  let "exist++"
	  #
	  # Existing entry found 
	  # continue with next result
	  #
	  continue
	fi
  fi
  #
  # New entry, get the MD5 of the file
  #
  pth=$(echo "$s" | awk -F '\t' '{print $2"/"$3}')
  pushd "$1" > /dev/null 2>&1
  hsh=$(md5sum -b "$pth")
  popd > /dev/null 2>&1
  echo -e "$s\t${hsh:0:32}" >> "$2"
  let "new++"
  #
  done
#
#
echo "$dsk" added:"$new" equal:"$exist" complete:"$pgs"%
#
# Cleanup
#
if [ ! -z "$file_exist" ]; then
  rm "$2$pfx"
fi
#
IFS=$SAVEIFS
