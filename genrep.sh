#!/bin/bash

sed -e 's/<[^>]*>/ /g' attacks.html| grep -E 'DDOS|MALWARE|XSS|SQL' | awk 'BEGIN {FS=" "; print "Attacks \tInstances"}{ print $1"\t""\t"$2 + $3 + $4}'
# sed statement replaces all html tags with nothing
# grep gets all matches that contain ddos malware xss or sql
# set awk fs to be a space, then print the information using \t to seperate the text into columns


exit