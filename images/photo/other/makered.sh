#!/bin/bash
langs='ru en'
diz='blp npi gray'
pref='/photo/JeepTrial2008/'
urls="index near_winter doma vypusknik delovie_ludi zaika_s_koshkoi"

echo "redirect_from:"
for u in $urls; do
	for d in $diz; do
		for l in $langs; do
			echo "  - \"$pref$u+$d+$l.html\""
		done
	done
done
