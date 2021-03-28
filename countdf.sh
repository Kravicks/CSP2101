#!/bin/bash
cd ~


EmptyFile=0
File=0
EmptyDirectory=0
Directory=0

for file in $1*; do
    
    if [[ -f $file ]]; then
        if [[ -s $file ]]; then
            File=$((File+1))
        else
            EmptyFile=$((EmptyFile+1))
        fi   
    elif [[ -d $file ]]; then
        
        if [ -z "$(ls -A $file)" ]; then
            EmptyDirectory=$((EmptyDirectory+1))
        else 
            Directory=$((Directory+1))
        fi
    fi
done
echo "The [$1] directory contains:
$File files that contain data
$EmptyFile files that are empty
$Directory non-empty directories
$EmptyDirectory directories"
exit 0