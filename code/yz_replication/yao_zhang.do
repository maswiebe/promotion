*-------------------------------------------------------------------------------
*** Yao and Zhang (2015)
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
*** Table 4
*-------------------------------------------------------------------------------
*** replicates original table, with two changes:
* clustering at prefecture level
* fix coding error in age dummy: stata treats missings as infinite (and hence above the threshold)

use "$root/code/yz_replication/Leader_Growth.dta", clear

encode(leader), g(lid3)
replace lid2=lid3
drop lid3
qui tab year, g(yeard)
drop yeard1

felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla yeard*, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) cons ftest
gen lfe_age=lfe_fs*age

gen age_cut = inrange(age,50,70) if missing(age)==0
gen lfeXage = lfe_fs*age_cut

eststo clear
qui:reghdfe prom_y lfe_fs age preprov ctenure, ab(pid year) vce(cl code06)
eststo m1
qui:reghdfe prom_y lfe_fs lfe_age age preprov ctenure, ab(pid year) vce(cl code06)
eststo m2
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m3

replace age_cut = inrange(age,51,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m4
replace age_cut = inrange(age,52,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m5
replace age_cut = inrange(age,53,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m6

lab var lfe_fs "Leader effect"
lab var lfe_age "Leader effect $\times$ Age"
lab var age "Age"
lab var preprov "Provincial experience"
lab var ctenure "Tenure"
lab var lfeXage "Leader effect $\times$ (Age $>$ threshold)"
lab var age_cut "Age $>$ threshold"

esttab m*, label replace se ar2 star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")
esttab m* using "$root/output/yao_zhang/table1.tex", label replace se ar2 star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")

*** original Table 4:
* don't cluster
* use incorrect age_cut variable

eststo clear
qui:reghdfe prom_y lfe_fs age preprov ctenure, ab(pid year)
eststo m1
qui:reghdfe prom_y lfe_fs lfe_age age preprov ctenure, ab(pid year)
eststo m2
replace age_cut = (age>=50)
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year)
eststo m3
replace age_cut = (age>=51)
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year)
eststo m4
replace age_cut = (age>=52)
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year)
eststo m5
replace age_cut = (age>=53)
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year)
eststo m6
esttab m*, label replace se ar2 star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")
esttab m* using "$root/output/yao_zhang/table_a2.tex", label replace se ar2 star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")


*-------------------------------------------------------------------------------
* replication: omit both inflation and population when estimating leader effects
use "$root/code/yz_replication/Leader_Growth.dta", clear

encode(leader), g(lid3)
replace lid2=lid3
drop lid3
qui tab year, g(yeard)
drop yeard1

felsdvreg rgdppcr1 loginigdppc yeard*, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) cons ftest
gen lfe_age=lfe_fs*age
gen age_cut = inrange(age,50,70) if missing(age)==0
gen lfeXage = lfe_fs*age_cut

eststo clear
qui:reghdfe prom_y lfe_fs age preprov ctenure, ab(pid year) vce(cl code06)
eststo m1
qui:reghdfe prom_y lfe_fs lfe_age age preprov ctenure, ab(pid year) vce(cl code06)
eststo m2
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m3

replace age_cut = inrange(age,51,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m4
replace age_cut = inrange(age,52,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m5
replace age_cut = inrange(age,53,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m6

lab var lfe_fs "Leader effect"
lab var lfe_age "Leader effect $\times$ Age"
lab var age "Age"
lab var preprov "Provincial experience"
lab var ctenure "Tenure"
lab var lfeXage "Leader effect $\times$ (Age $>$ threshold)"
lab var age_cut "Age $>$ threshold"

esttab m*, label replace se ar2 star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")
esttab m* using "$root/output/yao_zhang/table2.tex", label replace se ar2 star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")

*-------------------------------------------------------------------------------
* replication: omit inflation when estimating leader effects
use "$root/code/yz_replication/Leader_Growth.dta", clear

encode(leader), g(lid3)
replace lid2=lid3
drop lid3
qui tab year, g(yeard)
drop yeard1

felsdvreg rgdppcr1 loginigdppc logpoptot yeard*, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) cons ftest
gen lfe_age=lfe_fs*age
gen age_cut = inrange(age,50,70) if missing(age)==0
gen lfeXage = lfe_fs*age_cut

eststo clear
qui:reghdfe prom_y lfe_fs age preprov ctenure, ab(pid year) vce(cl code06)
eststo m1
qui:reghdfe prom_y lfe_fs lfe_age age preprov ctenure, ab(pid year) vce(cl code06)
eststo m2
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m3

replace age_cut = inrange(age,51,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m4
replace age_cut = inrange(age,52,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m5
replace age_cut = inrange(age,53,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m6

lab var lfe_fs "Leader effect"
lab var lfe_age "Leader effect $\times$ Age"
lab var age "Age"
lab var preprov "Provincial experience"
lab var ctenure "Tenure"
lab var lfeXage "Leader effect $\times$ (Age $>$ threshold)"
lab var age_cut "Age $>$ threshold"

esttab m*, label replace se ar2 star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")
esttab m* using "$root/output/yao_zhang/table_a6.tex", label replace se ar2 star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")

*-------------------------------------------------------------------------------
* replication: omit population when estimating leader effects
use "$root/code/yz_replication/Leader_Growth.dta", clear

encode(leader), g(lid3)
replace lid2=lid3
drop lid3
qui tab year, g(yeard)
drop yeard1

felsdvreg rgdppcr1 loginigdppc gdpdefla yeard*, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) cons ftest
gen lfe_age=lfe_fs*age
gen age_cut = inrange(age,50,70) if missing(age)==0
gen lfeXage = lfe_fs*age_cut

eststo clear
qui:reghdfe prom_y lfe_fs age preprov ctenure, ab(pid year) vce(cl code06)
eststo m1
qui:reghdfe prom_y lfe_fs lfe_age age preprov ctenure, ab(pid year) vce(cl code06)
eststo m2
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m3

replace age_cut = inrange(age,51,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m4
replace age_cut = inrange(age,52,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m5
replace age_cut = inrange(age,53,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:reghdfe prom_y lfe_fs lfeXage age_cut preprov ctenure, ab(pid year) vce(cl code06)
eststo m6

lab var lfe_fs "Leader effect"
lab var lfe_age "Leader effect $\times$ Age"
lab var age "Age"
lab var preprov "Provincial experience"
lab var ctenure "Tenure"
lab var lfeXage "Leader effect $\times$ (Age $>$ threshold)"
lab var age_cut "Age $>$ threshold"

esttab m*, label replace se ar2 star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")
esttab m* using "$root/output/yao_zhang/table_a7.tex", label replace se ar2 star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")

*-------------------------------------------------------------------------------
*** Table 5: Ordered probit
*-------------------------------------------------------------------------------

*** original Table 5
* don't cluster
* error in age_cut

use "$root/code/yz_replication/Leader_Growth.dta", clear
encode(leader), g(lid3)
replace lid2=lid3
drop lid3
gen togo=0
replace togo=1 if prom_y==1
replace togo=-1 if reti_y==1
replace togo=. if promotion==. | retire==.
qui tab year, g(yeard)
drop yeard1

felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla yeard*, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) cons ftest
gen lfe_age=lfe_fs*age
gen age_cut = (age>=50)
gen lfeXage = lfe_fs*age_cut

lab var lfe_fs "Leader effect"
lab var lfe_age "Leader effect $\times$ Age"
lab var age "Age"
lab var preprov "Provincial experience"
lab var ctenure "Tenure"
lab var lfeXage "Leader effect $\times$ (Age $>$ threshold)"
lab var age_cut "Age $>$ threshold"

eststo clear
qui:oprobit togo lfe_fs   age preprov ctenure  i.pid i.year
eststo m1
qui:oprobit togo lfe_fs lfe_age age preprov ctenure  i.pid i.year
eststo m2

qui:oprobit togo lfe_fs lfeXage age_cut preprov ctenure  i.pid i.year
eststo m3
replace age_cut = (age>=51)
replace lfeXage = lfe_fs*age_cut
qui:oprobit togo lfe_fs lfeXage age_cut preprov ctenure  i.pid i.year
eststo m4
replace age_cut = (age>=52)
replace lfeXage = lfe_fs*age_cut
qui:oprobit togo lfe_fs lfeXage age_cut preprov ctenure  i.pid i.year
eststo m5
replace age_cut = (age>=53)
replace lfeXage = lfe_fs*age_cut
qui:oprobit togo lfe_fs lfeXage age_cut preprov ctenure  i.pid i.year
eststo m6

esttab m* , label replace se star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52") eqlabels(none)
esttab m* using "$root/output/yao_zhang/table_a3.tex", label replace se star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52") eqlabels(none)

* replication: omit inflation and population when estimating leader effects
use "$root/code/yz_replication/Leader_Growth.dta", clear
encode(leader), g(lid3)
replace lid2=lid3
drop lid3
gen togo=0
replace togo=1 if prom_y==1
replace togo=-1 if reti_y==1
replace togo=. if promotion==. | retire==.
qui tab year, g(yeard)
drop yeard1

felsdvreg rgdppcr1 loginigdppc yeard*, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) cons ftest
gen lfe_age=lfe_fs*age
gen age_cut = inrange(age,50,70) if missing(age)==0
gen lfeXage = lfe_fs*age_cut

eststo clear
qui:oprobit togo lfe_fs   age preprov ctenure  i.pid i.year, vce(cl code06)
eststo m1
qui:oprobit togo lfe_fs lfe_age age preprov ctenure  i.pid i.year, vce(cl code06)
eststo m2

qui:oprobit togo lfe_fs lfeXage age_cut preprov ctenure  i.pid i.year, vce(cl code06)
eststo m3
replace age_cut = inrange(age,51,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:oprobit togo lfe_fs lfeXage age_cut preprov ctenure  i.pid i.year, vce(cl code06)
eststo m4
replace age_cut = inrange(age,52,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:oprobit togo lfe_fs lfeXage age_cut preprov ctenure  i.pid i.year, vce(cl code06)
eststo m5
replace age_cut = inrange(age,53,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut
qui:oprobit togo lfe_fs lfeXage age_cut preprov ctenure  i.pid i.year, vce(cl code06)
eststo m6

lab var lfe_fs "Leader effect"
lab var lfe_age "Leader effect $\times$ Age"
lab var age "Age"
lab var preprov "Provincial experience"
lab var ctenure "Tenure"
lab var lfeXage "Leader effect $\times$ (Age $>$ threshold)"
lab var age_cut "Age $>$ threshold"

esttab m* , label replace se star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52") eqlabels(none)
esttab m* using "$root/output/yao_zhang/table_a8.tex", label replace se star(* 0.1 ** 0.05 *** 0.01)  b(%9.3f) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) nocons mtitles("" "" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52") eqlabels(none)

*-------------------------------------------------------------------------------
*** Table 6: Linear-Linear model
*-------------------------------------------------------------------------------

*----------------------------------------------------------------------------
* original
*----------------------------------------------------------------------------

set more off
use "$root/code/yz_replication/Leader_Growth_logsc.dta", clear
* this dataset is created in the original code
eststo clear
cmp setup
gen lfe_fs3=0
qui tab leader, g(ld)
* leader effects
egen uniquelid=tag(lid2)
egen numlid=sum(uniquelid)
global i=numlid[1]
replace promnonmissing=prom_y<. | age<.
bysort lid2 code06: egen lastyearc=max(year)
gen goyear=lastyearc==year
gen togoyear=(/*goyear &*/ promnonmissing) * $cmp_cont
set mat 6000
by lid2: egen totten=max(ctenure)

xi: felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) cons
  global counter=0
  global tol=0.0005
  global stay=1
  replace lfe_age=lfe_fs*age
  replace lfe_fs3=0

  while $stay{
	global counter=$counter+1
	disp "$counter"
	cmp (growth: rgdppcr1= logpoptot loginigdppc  gdpdefla ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfe_age  age   preprov ctenure    ib32.pid ib2010.year), indicators($cmp_cont togoyear) nrtole(1e-4) tech(dfp nr)
	/* cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: prom_y =  lfe_fs lfe_age  age   preprov ctenure    ib32.pid ib2010.year), indicators($cmp_cont togoyear) nrtole(1e-4) tech(dfp nr) */
	* note: original code incorrectly used categorical promotion variable `togo`, not dummy `prom_y`

	gen lfe_fs2=0
	forvalues j=1/$i{
		capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
		}
	//demean
	egen meanlfe2=mean(lfe_fs2)
	replace lfe_fs2=lfe_fs2-meanlfe2
	//Convergence
	gen difflfe=abs(lfe_fs-lfe_fs2)
	egen meandiff=mean(difflfe)
	egen maxdiff=max(difflfe)
	replace lfe_fs3=lfe_fs
	replace lfe_fs=lfe_fs2
	replace lfe_age=lfe_fs*age
	if meandiff[1]<$tol & maxdiff[1]<2*$tol global stay=0
	drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
	}
	est sto m1


*Using age thresholds
* age 49
gen age_cut = (age>=50)
/* gen age_cut = inrange(age,50,70) if missing(age)==0 */
gen lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0

while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
/* cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: prom_y =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr) */
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m2

* age 50
replace age_cut = (age>=51)
/* replace age_cut = inrange(age,51,70) if missing(age)==0 */
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0

while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
/* cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: prom_y =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr) */
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m3

* age 51
replace age_cut = (age>=52)
/* replace age_cut = inrange(age,52,70) if missing(age)==0 */
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0

while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
/* cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: prom_y =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr) */
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m4

* age 52
replace age_cut = (age>=53)
/* replace age_cut = inrange(age,53,70) if missing(age)==0 */
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0

while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
/* cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: prom_y =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr) */
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m5

lab var lfe_fs "Leader effect"
lab var lfe_age "Leader effect $\times$ Age"
lab var age "Age"
lab var preprov "Provincial experience"
lab var ctenure "Tenure"
lab var lfeXage "Leader effect $\times$ (Age $>$ threshold)"
lab var age_cut "Age $>$ threshold"
lab var loginigdppc "Log initial GDPpc"

* promotion equation
esttab m* , label replace se star(* 0.1 ** 0.05 *** 0.01) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep( preprov age ctenure age lfe_fs lfe_age lfeXage age_cut) eqlabels(none) b(%9.3f) mtitles("" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")
esttab m* using "$root/output/yao_zhang/table_a4.tex", label replace se star(* 0.1 ** 0.05 *** 0.01) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep( preprov age ctenure age lfe_fs lfe_age lfeXage age_cut) eqlabels(none) b(%9.3f) mtitles("" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")


*----------------------------------------------------------------------------
* replication: omit inflation and population when estimating leader effects
*----------------------------------------------------------------------------

set more off
use "$root/code/yz_replication/Leader_Growth_logsc.dta", clear
* this dataset is created in the original code
eststo clear
cmp setup
gen lfe_fs3=0
qui tab leader, g(ld)
* leader effects
egen uniquelid=tag(lid2)
egen numlid=sum(uniquelid)
global i=numlid[1]
replace promnonmissing=prom_y<. | age<.
bysort lid2 code06: egen lastyearc=max(year)
gen goyear=lastyearc==year
gen togoyear=(/*goyear &*/ promnonmissing) * $cmp_cont
set mat 6000
by lid2: egen totten=max(ctenure)

xi: felsdvreg rgdppcr1 loginigdppc i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) cons
  global counter=0
  global tol=0.0005
  global stay=1
  replace lfe_age=lfe_fs*age
  replace lfe_fs3=0

  while $stay{
	global counter=$counter+1
	disp "$counter"
	// cmp (growth: rgdppcr1= logpoptot loginigdppc  gdpdefla ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfe_age  age   preprov ctenure    ib32.pid ib2010.year), indicators($cmp_cont togoyear) nrtole(1e-4) tech(dfp nr)
	cmp (growth: rgdppcr1= loginigdppc ld* ib2010.year ib3301.code06) (prom: prom_y =  lfe_fs lfe_age  age   preprov ctenure    ib32.pid ib2010.year), indicators($cmp_cont togoyear) nrtole(1e-4) tech(dfp nr)
	* note: original code incorrectly used categorical promotion variable, not dummy

	gen lfe_fs2=0
	forvalues j=1/$i{
		capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
		}
	//demean
	egen meanlfe2=mean(lfe_fs2)
	replace lfe_fs2=lfe_fs2-meanlfe2
	//Convergence
	gen difflfe=abs(lfe_fs-lfe_fs2)
	egen meandiff=mean(difflfe)
	egen maxdiff=max(difflfe)
	replace lfe_fs3=lfe_fs
	replace lfe_fs=lfe_fs2
	replace lfe_age=lfe_fs*age
	if meandiff[1]<$tol & maxdiff[1]<2*$tol global stay=0
	drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
	}
	est sto m1


*Using age thresholds
* age 49
gen age_cut = inrange(age,50,70) if missing(age)==0
gen lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0

while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc ld* ib2010.year ib3301.code06) (prom: prom_y =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m2

* age 50
replace age_cut = inrange(age,51,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0

while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc ld* ib2010.year ib3301.code06) (prom: prom_y =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m3

* age 51
replace age_cut = inrange(age,52,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0

while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc ld* ib2010.year ib3301.code06) (prom: prom_y =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m4

* age 52
replace age_cut = inrange(age,53,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0

while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc ld* ib2010.year ib3301.code06) (prom: prom_y =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m5

lab var lfe_fs "Leader effect"
lab var lfe_age "Leader effect $\times$ Age"
lab var age "Age"
lab var preprov "Provincial experience"
lab var ctenure "Tenure"
lab var lfeXage "Leader effect $\times$ (Age $>$ threshold)"
lab var age_cut "Age $>$ threshold"
lab var loginigdppc "Log initial GDPpc"

* promotion equation
esttab m* , label replace se star(* 0.1 ** 0.05 *** 0.01) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep( preprov age ctenure age lfe_fs lfe_age lfeXage age_cut) eqlabels(none) b(%9.3f) mtitles("" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")
esttab m* using "$root/output/yao_zhang/table_a9.tex", label replace se star(* 0.1 ** 0.05 *** 0.01) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep( preprov age ctenure age lfe_fs lfe_age lfeXage age_cut) eqlabels(none) b(%9.3f) mtitles("" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")

*-------------------------------------------------------------------------------
*** Table 7 replication
* Linear-ordered probit
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
* original
*-------------------------------------------------------------------------------
use "$root/code/yz_replication/Leader_Growth_logsc.dta", clear
eststo clear
cmp setup
gen lfe_fs3=0
qui tab leader, g(ld)
egen uniquelid=tag(lid2)
egen numlid=sum(uniquelid)
global i=numlid[1]
replace promnonmissing=prom_y<. | age<.
bysort lid2 code06: egen lastyearc=max(year)
gen goyear=lastyearc==year
gen togoyear=(promnonmissing) * $cmp_oprobit
set mat 6000
by lid2: egen totten=max(ctenure)

*Using age
xi: felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) cons
  global counter=0
  global tol=0.0005
  global stay=1
  replace lfe_age=lfe_fs*age
  replace lfe_fs3=0
  while $stay{
	global counter=$counter+1
	disp "$counter"
	cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfe_age  age   preprov ctenure    ib32.pid ib2010.year), indicators($cmp_cont togoyear) nrtole(1e-4) tech(dfp nr)

	gen lfe_fs2=0
	forvalues j=1/$i{
		capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
		}
	//demean
	egen meanlfe2=mean(lfe_fs2)
	replace lfe_fs2=lfe_fs2-meanlfe2
	//Convergence
	gen difflfe=abs(lfe_fs-lfe_fs2)
	egen meandiff=mean(difflfe)
	egen maxdiff=max(difflfe)
	replace lfe_fs3=lfe_fs
	replace lfe_fs=lfe_fs2
	replace lfe_age=lfe_fs*age
	if meandiff[1]<$tol & maxdiff[1]<2*$tol global stay=0
	drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
	}
	eststo m1

*Using age thresholds
* age 49
gen age_cut = (age>=50)
/* gen age_cut = inrange(age,50,70) if missing(age)==0 */
gen lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0
 while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m2

* age 50
replace age_cut = (age>=51)
/* replace age_cut = inrange(age,51,70) if missing(age)==0 */
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0
 while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m3

* age 51
replace age_cut = (age>=52)
/* replace age_cut = inrange(age,52,70) if missing(age)==0 */
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0
 while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m4

* age 52
replace age_cut = (age>=53)
/* replace age_cut = inrange(age,53,70) if missing(age)==0 */
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc logpoptot gdpdefla i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0
 while $stay{
global counter=$counter+1
cmp (growth: rgdppcr1= loginigdppc logpoptot gdpdefla ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m5

lab var lfe_fs "Leader effect"
lab var lfe_age "Leader effect $\times$ Age"
lab var age "Age"
lab var preprov "Provincial experience"
lab var ctenure "Tenure"
lab var lfeXage "Leader effect $\times$ (Age $>$ threshold)"
lab var age_cut "Age $>$ threshold"
lab var loginigdppc "Log initial GDPpc"

* promotion equation
esttab m* , label replace se star(* 0.1 ** 0.05 *** 0.01) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep(preprov age ctenure age lfe_fs lfe_age lfeXage age_cut) eqlabels(none) b(%9.3f) mtitles("" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")
esttab m* using "$root/output/yao_zhang/table_a5.tex", label replace se star(* 0.1 ** 0.05 *** 0.01) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep(preprov age ctenure age lfe_fs lfe_age lfeXage age_cut) eqlabels(none) b(%9.3f) mtitles("" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")


*-------------------------------------------------------------------------------
* replication
*-------------------------------------------------------------------------------

use "$root/code/yz_replication/Leader_Growth_logsc.dta", clear
eststo clear
cmp setup
gen lfe_fs3=0
qui tab leader, g(ld)
egen uniquelid=tag(lid2)
egen numlid=sum(uniquelid)
global i=numlid[1]
replace promnonmissing=prom_y<. | age<.
bysort lid2 code06: egen lastyearc=max(year)
gen goyear=lastyearc==year
gen togoyear=(promnonmissing) * $cmp_oprobit
set mat 6000
by lid2: egen totten=max(ctenure)

*Using age
xi: felsdvreg rgdppcr1 loginigdppc i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) cons
  global counter=0
  global tol=0.0005
  global stay=1
  replace lfe_age=lfe_fs*age
  replace lfe_fs3=0
  while $stay{
	global counter=$counter+1
	disp "$counter"
	cmp (growth: rgdppcr1= loginigdppc ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfe_age  age   preprov ctenure    ib32.pid ib2010.year), indicators($cmp_cont togoyear) nrtole(1e-4) tech(dfp nr)

	gen lfe_fs2=0
	forvalues j=1/$i{
		capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
		}
	//demean
	egen meanlfe2=mean(lfe_fs2)
	replace lfe_fs2=lfe_fs2-meanlfe2
	//Convergence
	gen difflfe=abs(lfe_fs-lfe_fs2)
	egen meandiff=mean(difflfe)
	egen maxdiff=max(difflfe)
	replace lfe_fs3=lfe_fs
	replace lfe_fs=lfe_fs2
	replace lfe_age=lfe_fs*age
	if meandiff[1]<$tol & maxdiff[1]<2*$tol global stay=0
	drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
	}
	eststo m1

*Using age thresholds
* age 49
gen age_cut = inrange(age,50,70) if missing(age)==0
gen lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0
 while $stay{
global counter=$counter+1
* remove pop,inflation from initial estimate of leader effect, as well as estimate of growth equation
cmp (growth: rgdppcr1= loginigdppc ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m2

* age 50
replace age_cut = inrange(age,51,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0
 while $stay{
global counter=$counter+1
* remove pop,inflation from initial estimate of leader effect, as well as estimate of growth equation
cmp (growth: rgdppcr1= loginigdppc ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m3

* age 51
replace age_cut = inrange(age,52,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0
 while $stay{
global counter=$counter+1
* remove pop,inflation from initial estimate of leader effect, as well as estimate of growth equation
cmp (growth: rgdppcr1= loginigdppc ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m4

* age 52
replace age_cut = inrange(age,53,70) if missing(age)==0
replace lfeXage = lfe_fs*age_cut

xi: felsdvreg rgdppcr1 loginigdppc i.year, ivar(lid2) jvar(code06) peff(lfe_fs) feff(cfe_ls) xb(predxb) res(e) mover(mover) g(g_id) mnum(mpc) pobs(lobs) noisily cons
global counter=0
global tol=0.0005
global stay=1
replace lfe_fs3=0
 while $stay{
global counter=$counter+1
* remove pop,inflation from initial estimate of leader effect, as well as estimate of growth equation
cmp (growth: rgdppcr1= loginigdppc ld* ib2010.year ib3301.code06) (prom: togo =  lfe_fs lfeXage age_cut   preprov ctenure   ib33.pid ib2010.year), indicators($cmp_cont togoyear)  nrtole(1e-4) tech(dfp nr)
gen lfe_fs2=0
forvalues j=1/$i{
	capture replace lfe_fs2=[growth]_b[ld`j'] if lid2==`j'
	}
//demean
egen meanlfe2=mean(lfe_fs2)
replace lfe_fs2=lfe_fs2-meanlfe2
//Convergence
gen difflfe=abs(lfe_fs-lfe_fs2)
egen meandiff=mean(difflfe)
egen maxdiff=max(difflfe)
replace lfe_fs3=lfe_fs
replace lfe_fs=lfe_fs2
replace lfeXage=lfe_fs*age_cut
if meandiff[1]<$tol & maxdiff<2*$tol global stay=0
drop meanlfe2 difflfe meandiff  maxdiff lfe_fs2
}
eststo m5

lab var lfe_fs "Leader effect"
lab var lfe_age "Leader effect $\times$ Age"
lab var age "Age"
lab var preprov "Provincial experience"
lab var ctenure "Tenure"
lab var lfeXage "Leader effect $\times$ (Age $>$ threshold)"
lab var age_cut "Age $>$ threshold"
lab var loginigdppc "Log initial GDPpc"

* promotion equation
esttab m* , label replace se star(* 0.1 ** 0.05 *** 0.01) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep(preprov age ctenure age lfe_fs lfe_age lfeXage age_cut) eqlabels(none) b(%9.3f) mtitles("" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")
esttab m* using "$root/output/yao_zhang/table_a10.tex", label replace se star(* 0.1 ** 0.05 *** 0.01) order(lfe_fs lfe_age age preprov ctenure lfeXage age_cut) keep(preprov age ctenure age lfe_fs lfe_age lfeXage age_cut) eqlabels(none) b(%9.3f) mtitles("" "Threshold: 49" "Threshold: 50" "Threshold: 51" "Threshold: 52")