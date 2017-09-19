#!/bin/bash
FILES="$@"
rm -rf thumb
mkdir thumb
for file in $FILES
do
        #This line convert the image in a 200 x 150 thumb 
        filename=$(basename "$file")
        extension="${filename##*.}"
        filename="${filename%.*}"
        convert -sample 200x450 "$file" "thumb/${filename}-thumb.${extension}" 
done
