#!/bin/bash

sum=$(($1+$2+$3))

if [ $sum -le 30 ]; then
    echo "The sum of $1 and $2 and $3 is $sum"
else
    echo "Sum exceeds maxmimum allowable"
fi
exit 0