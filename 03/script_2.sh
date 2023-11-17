#!/bin/bash

if ! [[ -e "./2" ]];then
    mkdir ./2
fi

FILE="./2/data.txt"
if [[ -f "$FILE" ]];then
    #s to substituite, g to do it for all the occurrences
    sed -e "s/,//g" "data.csv" | grep -v "^#" > "$FILE" 
fi
