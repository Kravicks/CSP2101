#!/bin/bash


read -p "Enter number" number
until [[ $number =~ ^[0-9]+$ ]] && [[ $number = 20 || $number = 40 ]]; do
    echo "Invalid entry"
    read -p "Enter number" number    
    continue
done
echo "You have entered the correct integer"
exit 0