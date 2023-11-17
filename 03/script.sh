#!/bin/bash

#checking if the folder exists
if ! [[ -e "students" ]];then
    mkdir ./students
fi

#checking if the file exists
FILE=./students/LCP_22-23_students.csv
if test -f "$FILE";then
    echo "$FILE exists."
else
    wget https://www.dropbox.com/s/867rtx3az6e9gm8/LCP_22-23_students.csv -P ./students
fi

#Excercise 1.b
if ! [[ -e "./1.b" ]];then
    mkdir ./1.b
fi
echo "Creating a file for PoD and another one for Physics"

output_file="./1.b/PoD.csv"
head -n 1 "$FILE" > "$output_file"

#-i for case insensitive: ignore case
grep -i ",PoD" "$FILE" >> "$output_file"
echo "Filtered lines with 'PoD' master program saved to $output_file"

output_file="./1.b/Physics.csv"
echo "" > "$output_file"

#-v invert the statement: print all the lines that do not contain PoD
grep -i -v ",PoD" "$FILE" >> "$output_file"
echo "Filtered lines with 'Physics' master program saved to $output_file"

echo "-------------------------------------"

#Excercise 1.c
echo "For each letter of the alphabet, count the number of students whose surname starts with that letter" 

for letter in {A..Z}; do
    count=$(grep -c "^$letter" "$FILE")
    echo "$letter: $count"
done

echo "-------------------------------------"
#Excercise 1.d 
max=0
l="-1"

for letter in {A..Z}; do
    count=$(grep -c "^$letter" "$FILE")
    if [ $count -gt $max ];then
        max=$count
        l=$letter
    fi
done

echo "The letter with most counts is $l with $max counts"

echo "-------------------------------------"
#Excercise 1.e
echo "Let's group the students modulo 18"

if ! [ -e "./1.e" ];then
    mkdir "./1.e"
fi
# field separator (IFS) is set to the empty string to preserve whitespace issues. This is a fail-safe feature
#The -r option is used not to allow backslashes to escape any characters

for (( i=0; i<=17; i++ )); do
    head -n 1 "$FILE" > "./1.e/group_$i.csv"
done

count=1
while IFS= read -r line
do
    echo "$line" >> "./1.e/group_$count.csv"
    let "count=$count+1"
    let "count=$count%18"
done < "$FILE"
echo "Done"