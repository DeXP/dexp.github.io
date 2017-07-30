#!/bin/bash
langs='ru en'
diz='blp npi gray'
pref='/photo/sea2008/'
urls="index s08_dolinska s08_me_with_father s08_me_alushta s08_cool_photo s08_philosopher s08_wave s08_sea s08_father_swimming s08_stones s08_father_and_sea s08_cosmetic_bodyaga s08_sea_at_evening s08_father_and_table s08_with_notebook s08_sunset s08_me_and_sunset s08_wave_runner s08_grasshopper s08_father_and_Shurik"

echo "redirect_from:"
for u in $urls; do
	for d in $diz; do
		for l in $langs; do
			echo "  - \"$pref$u+$d+$l.html\""
		done
	done
done
