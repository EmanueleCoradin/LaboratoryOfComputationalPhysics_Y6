#!/bin/bash

function f() {
    echo "" > "./2.e/data_$1.csv"
    while IFS=" " read -r linef
    do
        #loop on the string
        newline=""
        for numberf in $linef
        do
            newline+="$(echo "$numberf / $1" | bc -l) "
        done
        echo $newline >> "./2.e/data_$1.csv"
    done < $2

}


#2.a
if ! [[ -e "./2" ]];then
    mkdir ./2
fi

FILE="./2/data.txt"
if [[ -f "$FILE" ]];then
    #s to substituite, g to do it for all the occurrences
    sed -e "s/,//g" "data.csv" | grep -v "^#" > "$FILE" 
fi

#2.b
#read the file
even=0
while IFS=" " read -r line
do
    #loop on the string
    for number in $line
        do
        if [ $(($number % 2)) -eq 0 ];then
            let even=$even+1
        fi
    done
done < "$FILE"
echo "Present $even even numbers"

#2.c
#scale indicate the digit precision
#bc stands for basic calculator
comp=$(bc <<< "scale=2; sqrt(2)*100/2")
echo "I'll compare $comp with the norm of each line vector"

greater=0
smaller=0

while IFS=" " read -r line
do
    #convert each line into an array
    stringarray=($line)
    #loop on the array
    x=${stringarray[0]}
    y=${stringarray[1]}
    z=${stringarray[2]}
    norm=$(bc <<< "scale=2; sqrt($x^2+$y^2+$z^2)")
    #he option -l is equivalent to --mathlib; it loads the standard math library.
    #Enclosing the whole expression between double parenthesis (( )) will translate these values to respectively true or false.
    if (( $(echo "$norm > $comp" | bc -l) )); then
        let greater=$greater+1
    else
        let smaller=$smaller+1
    fi
done < "$FILE"

echo "There are $greater greater numbers" 
echo "There are $smaller smaller numbers"
echo "----------------------------------"

#2.d
if ! [[ -e "./2.e" ]];then
    mkdir ./2.e
fi

while getopts "hn:" flag; do
    case $flag in
        n) # Handle the -n flag with an argument
            number=$OPTARG
            echo "n = $number"
            for (( i=1; i<=$number; i++ )); do
                f $i "$FILE" 
            done
            ;;
        h|\?)
            # Handle help or invalid options
            echo "Usage: $0 [-n number]"
            echo "  -n : Specify a number to execute the last exercise."
            echo "  -h : Display this help message."
            ;;
    esac
done