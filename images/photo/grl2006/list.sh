#!/bin/bash
prfx=`pwd | sed 's/.*\images\///'`
#prfx='photo/JeepTrial2008'
echo "gallery:"
for file in *.JPG
do
	if [[ $file != *"thumb"* ]]; then
		echo "    - image_url: $prfx/$file"
	fi
done
