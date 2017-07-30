#!/bin/bash
langs='ru en'
diz='blp npi gray'
pref='/photo/mozyr2007/'
urls="index linuksoid_pasha spat_hochy marsh1 marsh2 chesem cherty cherty2_vozvrzshenie lesenka cultural_people havchik reading_contest try_to_think razminka cherty_i_korotkevich cheshem_obratno 3_mushketera pekun-windows"

echo "redirect_from:"
for u in $urls; do
	for d in $diz; do
		for l in $langs; do
			echo "  - \"$pref$u+$d+$l.html\""
		done
	done
done
