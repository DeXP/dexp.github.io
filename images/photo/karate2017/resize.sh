#!/bin/bash
FILES="$@"
rm -rf resize
mkdir resize
for file in $FILES
do
        convert -sample 2048x1536 "$file" "resize/${file}" 
done
