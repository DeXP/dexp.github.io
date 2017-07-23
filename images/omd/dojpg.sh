#!/bin/bash
FILES="$@"
for file in $FILES
do
        #This line convert the image in a 200 x 150 thumb 
        filename=$(basename "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"
        convert "$file" "${filename}.jpg" 
done
