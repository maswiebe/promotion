*-------------------------------------------------------------------------------
*** Chen and Kung 2019
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
*** create datasets with promotion variables

* yao zhang
use "$root/code/yz_replication/Leader_Growth.dta", clear
keep if secretary==0
rename code06 prefcode
rename promotion everpromoted
rename prom_y promotion
rename ctenure tenure
gen oprom = 0 if promotion==0
replace oprom = 1 if promotion==1
replace oprom = -1 if reti_y==1
* same as 'togo' in Leader_Growth_logsc.dta


keep prefcode year promotion oprom tenure yob firstyear lastyear reti_y leader
rename leader name_yz
rename promotion promotion_yz
rename oprom oprom_yz
rename tenure tenure_yz
rename yob birthyear_yz
rename firstyear firstyear_yz
rename lastyear lastyear_yz
rename reti_y retire_yz
save "$root/code/yz_replication/promotion_yz.dta", replace

* li et al
import delimited "$root/code/li_etal_replication/promotion.csv", clear
gen prefcode=city/100
keep if pos==0
gen birthyear = year - age
rename on_seat_yr tenure

keep prefcode year promotion age tenure edu birthyear
rename birthyear birthyear_li
rename promotion promotion_li
rename age age_li
rename tenure tenure_li
rename edu edu_li
save "$root/code/li_etal_replication/promotion_li.dta", replace

* chen kung
use "$root/code/ck_replication/prefecture_panel.dta", clear
drop if ps==1
gen prefcode = prefid/100
keep prefcode year promote1
rename promote1 promotion_ck
save "$root/code/ck_replication/promotion_ck.dta", replace

*-------------------------------------------------------------------------------
*** data error in prefecture mayors

use "$root/code/ck_replication/prefecture_panel.dta", clear
merge 1:1 prefid year ps using "$root/code/ck_replication/prefecture_leaders.dta"
    * note: this data was provided by James Kung; not available in the original replication files
drop _merge
drop if ps==1
drop if missing(name)
duplicates drop name birthy year, force
* have four cases of the same mayor in two prefectures
egen leader = group(name birthy)
drop if missing(leader)
* need name and birth year to distinguish people
egen leaderpref = group(leader prefid)

drop if missing(promote1)
* they have a bunch of observations with promotion missing

tsset leaderpref year
* needs to be leaderpref, since different leaders across prefectures; restart _seq when changing prefs
tsspell leaderpref

* problem: promote1 is supposed to be an annual promotion variable, =1 if mayor is promoted in that year; so should be =1 only in last year of a mayor's spell.
  * but many observations are wrong: have promote1=1 in multiple years of a mayor's spell
  * 5% of leader spells have data errors, with promote1=1 more than once
  * same error in the ordinal 'promote' variable, since promote1=(promote==3)

egen sum = sum(promote1), by(leaderpref)
gen error = (sum>1)
tab error
* 205 errors

* number of times promotion=1 by spell
preserve
collapse sum error, by(leaderpref)
su error
* 51/1104 = 4.6% of spells
tab sum
restore

* out of 201 cases of promotion=1, 122 occur before, and 79 occur in the mayor's last year in office.
tab promote1 _end

* fix: create an everpromoted variable (take max of promote by spell), and define promotion=1 if _end=1 (last year of spell) and everpromoted=3
  * count of promotions is reduced from 201 to 87; more than 50% reduction in the promotion rate
* number of erroneous promotions: 201-87 = 114

egen everpromoted = max(promote), by(leaderpref _spell) 
gen promotion_fix = 1 if everpromoted==3 & _end==1
replace promotion_fix = 0 if missing(promotion_fix)

* are there cases of demotion/retirement that are wrong?
gen retire = (promote==1)
egen everretired = max(retire), by(leaderpref _spell)
gen demote = (promote==0)
egen everdemoted = max(demote), by(leaderpref _spell)
*bro prefid year promote promote1 leader retire everretired demote everdemoted if everretired==1
* yes

tab promote1
* 201 promotions
tab promotion_fix
* 87 promotions

* categorical variable
  * use _end==1 to fix errors
gen opromfix = 2
replace opromfix = 1 if promote==1 & _end==1
replace opromfix = 0 if promote==0 & _end==1
replace opromfix = 3 if promotion_fix==1 & _end==1
* have one case where everpromoted==1 but promote==1 in last year
  * prefid==330100, year== 2012


gen prefcode = prefid/100

merge 1:1 prefcode year using "$root/code/ck_replication/promotion_wiebe.dta"
rename promotion2 promotion_wiebe
rename opromotion opromotion_wiebe
rename promotion5 promotion_wiebe_strict
rename opromotion5 opromotion_wiebe_strict

*-------------------------------------------------------------------------------
*** promotion rate using fixed (corrected) promotion variable
set scheme plotplainblind

preserve
collapse promotion_wiebe promotion_wiebe_strict promote1 promotion_fix, by(year)
tw line promote1 promotion_fix promotion_wiebe_strict year if inrange(year,2004,2014), title("") legend(label(1 "Chen and Kung: original") label(2 "Chen and Kung: corrected") label(3 "Wiebe (2020): strict")) xtitle("") lpattern("_" "-" "1") legend(pos(6) row(1)) lcolor("red" "gray" "black")

graph export "$root/output/chen_kung/fig3.png", replace
graph export "$root/output/chen_kung/fig3.pdf", replace
graph export "$root/output/chen_kung/fig3.eps", replace

restore

*-------------------------------------------------------------------------------
* redo Table IX with corrected promotion variable
eststo clear
qui:oprobit opromfix princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.prefid i.year if year>=2004 & ps==0
eststo m1
qui:reghdfe promotion_fix princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear if year>=2004 & ps==0, ab(prefid year)
eststo m2
qui:oprobit opromfix discount ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.prefid i.year if year>=2004 & ps==0
eststo m3
qui:oprobit opromfix lnarea ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.prefid i.year if year>=2004 & ps==0
eststo m4
esttab m1 m2 m3 m4, nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(princeling discount lnarea ties gdpgrowth revgrowth) order(princeling discount lnarea ties gdpgrowth revgrowth) eqlabels(none) b(%9.3f)
esttab m1 m2 m3 m4 using "$root/output/chen_kung/table_a13.tex", nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(princeling discount lnarea ties gdpgrowth revgrowth) order(princeling discount lnarea ties gdpgrowth revgrowth) eqlabels(none) b(%9.3f)


*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------------------
*** original Table IX with ck promotion data

use "$root/code/ck_replication/prefecture_panel.dta", clear
drop if ps==1

eststo clear
qui:oprobit promote princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.prefid i.year if year>=2004 & ps==0
eststo m1
qui:reghdfe promote1 princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear if year>=2004 & ps==0, ab(prefid year)
eststo m2
qui:oprobit promote discount ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.prefid i.year if year>=2004 & ps==0
eststo m3
qui:oprobit promote lnarea ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear i.prefid i.year if year>=2004 & ps==0
eststo m4
esttab m1 m2 m3 m4, nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(princeling discount lnarea ties gdpgrowth revgrowth) order(princeling discount lnarea ties gdpgrowth revgrowth) eqlabels(none) b(%9.3f)
esttab m1 m2 m3 m4 using "$root/output/chen_kung/table_a12.tex", nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(princeling discount lnarea ties gdpgrowth revgrowth) order(princeling discount lnarea ties gdpgrowth revgrowth) eqlabels(none) b(%9.3f)

*-------------------------------------------------------------------------------
*** Table IX with promotion data from Wiebe (2020), Li et al. (2019), Yao and Zhang (2015)

gen prefcode = prefid/100

merge 1:1 prefcode year using "$root/code/ck_replication/promotion_wiebe.dta"
drop _merge
rename promotion2 promotion_wiebe
rename opromotion opromotion_wiebe
rename promotion5 promotion_wiebe_strict
rename opromotion5 opromotion_wiebe_strict

merge 1:1 prefcode year using "$root/code/li_etal_replication/promotion_li.dta"
drop _merge

merge 1:1 prefcode year using "$root/code/yz_replication/promotion_yz.dta"
drop _merge

* match original sample as closely as possible
reghdfe promote1 princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear if year>=2004 & ps==0, ab(prefid year) vce(cl prefid)
gen ck_sample = e(sample)
reghdfe promotion_wiebe princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear if year>=2004 & ps==0 & ck_sample==1, ab(prefid year) vce(cl prefid)
gen wiebe_sample = e(sample)
reghdfe promotion_li princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear if year>=2004 & ps==0 & ck_sample==1, ab(prefid year) vce(cl prefid)
gen li_sample = e(sample)
reghdfe promotion_yz princeling ties gdpgrowth lngdppc lnpop revgrowth age age2 eduyear if year>=2004 & ps==0 & ck_sample==1, ab(prefid year) vce(cl prefid)
gen yz_sample = e(sample)

* chen and kung original
eststo clear
qui:oprobit promote gdpgrowth lngdppc lnpop revgrowth i.prefid i.year if year>=2004 & ps==0 & ck_sample==1, vce(cl prefid)
eststo m1
qui:reghdfe promote1 gdpgrowth lngdppc lnpop revgrowth if year>=2004 & ps==0 & ck_sample==1, ab(prefid year) vce(cl prefid)
eststo m2
esttab m1 m2 m1 m2, nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(gdpgrowth ) order( gdpgrowth) eqlabels(none) mgroups("Ordered probit" "LPM" "Ordered probit" "LPM", pattern(1 1 1 1)) b(%9.3f)
esttab m1 m2 m1 m2 using "$root/output/chen_kung/table5_ck.tex", nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(gdpgrowth ) order( gdpgrowth) eqlabels(none) mgroups("Ordered probit" "LPM" "Ordered probit" "LPM", pattern(1 1 1 1)) b(%9.3f)
* replace col 3-4 with empty strings

* wiebe
eststo clear
qui:oprobit promote gdpgrowth lngdppc lnpop revgrowth i.prefid i.year if year>=2004 & ps==0 & wiebe_sample==1, vce(cl prefid)
eststo m1
qui:reghdfe promote1 gdpgrowth lngdppc lnpop revgrowth if year>=2004 & ps==0 & wiebe_sample==1, ab(prefid year) vce(cl prefid)
eststo m2
qui:oprobit opromotion_wiebe gdpgrowth lngdppc lnpop revgrowth i.prefid i.year if year>=2004 & ps==0 & wiebe_sample==1, vce(cl prefid)
eststo m3
qui:reghdfe promotion_wiebe gdpgrowth lngdppc lnpop revgrowth if year>=2004 & ps==0 & wiebe_sample==1, ab(prefid year) vce(cl prefid)
eststo m4
qui:oprobit opromotion_wiebe_strict gdpgrowth lngdppc lnpop revgrowth i.prefid i.year if year>=2004 & ps==0 & wiebe_sample==1, vce(cl prefid)
eststo m5
qui:reghdfe promotion_wiebe_strict gdpgrowth lngdppc lnpop revgrowth if year>=2004 & ps==0 & wiebe_sample==1, ab(prefid year) vce(cl prefid)
eststo m6

esttab m1 m2 m3 m4, nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(gdpgrowth ) order( gdpgrowth ) eqlabels(none) mgroups("Ordered probit" "LPM" "Ordered probit" "LPM", pattern(1 1 1 1)) b(%9.3f)
esttab m1 m2 m3 m4 using "$root/output/chen_kung/table5_wiebe.tex", nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(gdpgrowth ) order( gdpgrowth) eqlabels(none) mgroups("Ordered probit" "LPM" "Ordered probit" "LPM", pattern(1 1 1 1)) b(%9.3f)

* wiebe, strict definition
esttab m5 m6, nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(gdpgrowth ) order( gdpgrowth ) eqlabels(none) mgroups("Ordered probit" "LPM", pattern(1 1)) b(%9.3f)
esttab m5 m6 using "$root/output/chen_kung/table5_wiebe_strict.tex", nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(gdpgrowth ) order( gdpgrowth ) eqlabels(none) mgroups("Ordered probit" "LPM", pattern(1 1)) b(%9.3f)

* li et al.
  * no ordered promotion variable, so can't do ordered probit
eststo clear
*qui:oprobit promote gdpgrowth lngdppc lnpop revgrowth i.prefid i.year if year>=2004 & ps==0 & li_sample==1, vce(cl prefid)
*eststo m1
qui:reghdfe promote1 gdpgrowth lngdppc lnpop revgrowth if year>=2004 & ps==0 & li_sample==1, ab(prefid year) vce(cl prefid)
eststo m2
*qui:oprobit opromotion_li gdpgrowth lngdppc lnpop revgrowth i.prefid i.year if year>=2004 & ps==0 & li_sample==1, vce(cl prefid)
*eststo m3
qui:reghdfe promotion_li gdpgrowth lngdppc lnpop revgrowth if year>=2004 & ps==0 & li_sample==1, ab(prefid year) vce(cl prefid)
eststo m4
esttab m*, nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(gdpgrowth ) order( gdpgrowth ) eqlabels(none) mgroups("LPM" "LPM", pattern(1 1)) b(%9.3f)
esttab m* using "$root/output/chen_kung/table5_li.tex", nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(gdpgrowth ) order( gdpgrowth) eqlabels(none) mgroups("LPM" "LPM", pattern(1 1)) b(%9.3f)

* yao zhang
eststo clear
qui:oprobit promote gdpgrowth lngdppc lnpop revgrowth i.prefid i.year if year>=2004 & ps==0 & yz_sample==1, vce(cl prefid)
eststo m1
qui:reghdfe promote1 gdpgrowth lngdppc lnpop revgrowth if year>=2004 & ps==0 & yz_sample==1, ab(prefid year) vce(cl prefid)
eststo m2
qui:oprobit oprom_yz gdpgrowth lngdppc lnpop revgrowth i.prefid i.year if year>=2004 & ps==0 & yz_sample==1, vce(cl prefid)
eststo m3
qui:reghdfe promotion_yz gdpgrowth lngdppc lnpop revgrowth if year>=2004 & ps==0 & yz_sample==1, ab(prefid year) vce(cl prefid)
eststo m4
esttab m*, nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(gdpgrowth ) order( gdpgrowth ) eqlabels(none) mgroups("Ordered probit" "LPM" "Ordered probit" "LPM", pattern(1 1 1 1)) b(%9.3f)
esttab m* using "$root/output/chen_kung/table5_yz.tex", nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) keep(gdpgrowth ) order( gdpgrowth) eqlabels(none) mgroups("Ordered probit" "LPM" "Ordered probit" "LPM", pattern(1 1 1 1)) b(%9.3f)

* combined table: https://github.com/steveofconnell/PanelCombine

*include "https://raw.githubusercontent.com/steveofconnell/PanelCombine/master/PanelCombine.do"
panelcombine, use($root/output/chen_kung/table5_ck.tex $root/output/chen_kung/table5_yz.tex $root/output/chen_kung/table5_li.tex $root/output/chen_kung/table5_wiebe.tex $root/output/chen_kung/table5_wiebe_strict.tex)  columncount(4) paneltitles("Chen and Kung (2019)" "Yao and Zhang (2015)" "Li et al. (2019)" "Wiebe (2020)" "Wiebe (2020): strict definition") save($root/output/chen_kung/table5.tex)
* 'cleanup' seems to delete input files
* need to manually add empty columns in combined .tex file

* Chen and Kung - Panel A
/* GDP Growth          &       2.638\sym{**} &       0.361\sym{***}&        &       \\
&     (1.077)         &     (0.097)         &              &              \\
\hline
Observations        &        2569         &        2569         &                 &                 \\
Adjusted \(R^{2}\)  &                     &       0.373         &                     &                \\ */

* Li et al - Panel C
/* GDP Growth          &                &       0.425\sym{***} &                &       0.006         \\
&              &     (0.096)         &              &     (0.142)         \\
\hline
Observations        &                 &        2124         &                 &        2124         \\
Adjusted \(R^{2}\)  &                     &       0.397         &                     &       0.065         \\ */

* Wiebe (strict definition) - panel E:
/* GDP Growth          &                &        &       -0.497         &       0.022         \\
&              &              &     (0.894)         &     (0.046)         \\
\hline
Observations        &                 &                 &        2549         &        2549         \\
Adjusted \(R^{2}\)  &                     &                &                     &       0.012         \\ */

*-------------------------------------------------------------------------------
*** promotion rate: compare to literature

use "$root/code/ck_replication/promotion_wiebe.dta", clear
rename promotion2 promotion_wiebe

merge 1:1 prefcode year using "$root/code/yz_replication/promotion_yz.dta"
rename _merge merge_yz

merge 1:1 prefcode year using "$root/code/li_etal_replication/promotion_li.dta"
rename _merge merge_li

merge 1:1 prefcode year using "$root/code/ck_replication/promotion_ck.dta"
rename _merge merge_kung

set scheme plotplainblind

* unbalanced panel, 2004-2010
    * different samples in different datasets

table year if inrange(year,2004,2010), c(count promotion_ck count promotion_li count promotion_yz count promotion_wiebe)
preserve
collapse (count) promotion_wiebe promotion_li promotion_yz promotion_ck if inrange(year,2004,2010)
su
* ck: 2002
* li: 1870
* yz: 1220
* wiebe: 2248
restore

preserve
collapse promotion_wiebe promotion_li promotion_yz promotion_ck, by(year)
tw line promotion_wiebe promotion_li promotion_yz promotion_ck year if inrange(year,2004,2010), legend(label(1 "Wiebe") label(2 "Li et al.") label(3 "Yao and Zhang") label(4 "Chen and Kung") pos(6) row(2)) xtitle("") lpattern("1" "...-" "-" "_") lcolor("black" "gray" "cyan" "red")
graph export "$root/output/chen_kung/fig2.png", replace
graph export "$root/output/chen_kung/fig2.pdf", replace
graph export "$root/output/chen_kung/fig2.eps", replace
restore