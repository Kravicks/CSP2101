#!/bin/bash

# Seperator uses any amount of spaces to seperate variables
# First regex statement has a pattern includes passwords with uppercase and a digit and at least 8 characters
# Second regex statemend has a pattern that includes passwords that doesnt contain at least one of the previous conditions 
awk 'BEGIN {FS="[[:space:]]"}
    $2 ~/[[:upper:]]/ && $2 ~/[[:digit:]]/ && $2 ~/^[[:alnum:]]{8,}$/ {print $2 " - Valid Password"}  
    $2 !~/[[:upper:]]/ || $2 !~/[[:digit:]]/ || $2 !~/^[[:alnum:]]{8,}$/  {print $2 " - Invalid Password"} 
    
     
    ' usrpwords.txt # get input from the usrpwords.txt file
    
exit 