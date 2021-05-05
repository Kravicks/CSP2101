#!/bin/bash



 
getprop() # decalre the function getprop

    fsize=$(du  -k $fname | cut -f1) # get the size of the file
    wcount=$(wc -l < $fname) # get the word count of the file
    lastMod=$(date -r $fname +"%d-%m-%y %H:%M:%S") # get the date that the file was last modified and format it d/m/y h/m/s
    echo "The file $fname contains $wcount words and is $fsize K in size and was last modified $lastMod" # Echo the properties of the file
    
    
} 


read -p "Enter File Name: " fname # Get the file name of the file that the user wants to get the properties of
getprop $fname # call the function getprop      
exit
