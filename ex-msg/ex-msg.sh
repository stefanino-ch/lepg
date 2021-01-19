#/usr/bin/bash

# Extract all message to translate in a Tcl project resident in folder lepg/
# 2021-01-12

# Extract all lines with translations
grep -nR '::msgcat::mc' lepg/ > listmsg.txt

rm list_to_translate.txt

# Extract strings beetwen ""
while read line
do

name1=${line%\"*}

name2=${name1##*\"}

name3="\"$name2\""

echo $name3 >> list_to_translate.txt

done < listmsg.txt

# And sort unic lines...!
sort list_to_translate.txt | uniq -u > list_unic.txt


