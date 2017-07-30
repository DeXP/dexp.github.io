#!/bin/bash
langs='ru en'
diz='blp npi gray'
pref='/photo/JeepTrial2008/'
urls="index jt2008_beginning jt2008_opel_kadett jt2008_svjat jt2008_mustang jt2008_spare_wheel jt2008_prp_in_proc jt2008_at_the_top jt2008_89 jt2008_not_simple_obstacles jt2008_50 jt2008_bikes jt2008_hobbit jt2008_swimming jt2008_swimming_rescue jt2008_atv_swimming jt2008_eared_in_action jt2008_UAZ_ezdit jt2008_firefly jt2008_pipe jt2008_start jt2008_race_process jt2008_race_favorits jt2008_sr jt2008_opel_jumping jt2008_overtaking jt2008_wh_brest jt2008_dust jt2008_seats jt2008_seats jt2008_opel_last"

echo "redirect_from:"
for u in $urls; do
	for d in $diz; do
		for l in $langs; do
			echo "  - \"$pref$u+$d+$l.html\""
		done
	done
done
