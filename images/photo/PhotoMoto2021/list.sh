#!/bin/bash
prfx=`pwd | sed 's/.*\images\///'`
prfx='photo/PhotoMoto2021'
echo "gallery:"
for file in *.jpg
do
	if [[ $file != *"thumb"* ]]; then
		echo "    - image_url: $prfx/$file"
	fi
done
