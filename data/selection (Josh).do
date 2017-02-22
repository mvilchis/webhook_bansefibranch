cd "/Users/joshmartin/Desktop/Mexico - selection Dec 2016"

*OBJECTIVE: Choose a sensible number of localities for randomization, 
*			then build strata and conduct randomization
*			for Mexico Prospera CCT project (ideas42)

use localidades_sample, clear

*---PART I: CHOOSE A NUMBER OF LOCALITIES THAT MAKES SENSE---
*		(i.e. more than 60, but geographpically localized to minimize rollout costs)

egen num_per_state = count(im_2), by(Desc_edo)
drop if num_per_state<8

*---PART II: BUILD STRATA---

*	Marginality
	sum im_2, detail
	local median=r(p50)
	gen bin_im=1
	replace bin_im=2 if im_2>`median'

*	distance
	sum distance, detail
	local median=r(p50)
	gen bin_dist=1
	replace bin_dist=2 if  distance>`median'

*	# beneficiaries
	sum totfam_m, detail
	local median=r(p50)
	gen bin_benef=1
	replace bin_benef=2 if  totfam_m>`median'

*---PART III: CONDUCT RANDOMIZATION---
*Procedure:
* 	First sort the data, assign the random number seed, generate a random number
* 	for each unit, and then rank this number within each strata. We also create 
* 	the assignment variable.

set seed 161210
gen rand=runiform()
sort bin_* rand

gen assignment=mod(_n,2)
label define assignment 0 Control 1 Treatment
label values assignment assignment
bro Desc_edo bin_* rand assignment

*FINAL: SAVE DATA (both Stata and simplified Excel formats)

save RANDOMIZED_161210.dta, replace
keep Cve* Desc* nom_* LocalidadId loc_id im_2010 distance totfam_m BLOQUE Canal_dm type assignment
order Cve* Desc* nom_* LocalidadId loc_id im_2010 distance totfam_m BLOQUE Canal_dm type assignment
outsheet using RANDOMIZED_161210.xls, replace
