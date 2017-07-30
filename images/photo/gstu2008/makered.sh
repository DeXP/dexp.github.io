#!/bin/bash
langs='ru en'
diz='blp npi gray'
pref='/photo/gstu2008/'
urls="index gstu_tati_and_imdagger gstu_bigi_and_mikolka gstu_rokalo_and_anihovsky gstu_eskov_and_lapeko gstu_mikolka gstu_tati gstu_bigi gstu_rizar gstu_korobejnikova_task gstu_timox gstu_kapusta gstu_kleiner gstu_shugaev gstu_308 gstu_kurochka gstu_korotkevich gstu_start_rewarding gstu_process_of_rewarding gstu_korotkevich_rewarding gstu_no_comments gstu_korobejnikova gstu_me"

echo "redirect_from:"
for u in $urls; do
	for d in $diz; do
		for l in $langs; do
			echo "  - \"$pref$u+$d+$l.html\""
		done
	done
done
