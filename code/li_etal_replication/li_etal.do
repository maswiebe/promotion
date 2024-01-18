*-------------------------------------------------------------------------------
*** Li et al. (2019)
*-------------------------------------------------------------------------------

*-------------------------------------------------------------------------------
*** Table 5
*-------------------------------------------------------------------------------

import delimited "$root/code/li_etal_replication/promotion.csv", clear
* note: their cityprom.csv has two column headers merged, which are correctly separated here

gen prefcode=city/100
gen age2 = age*age

rename real gdpgrowth
rename cumreal avggdp
rename on_seat_yr tenure

replace gdpgrowth = gdpgrowth/100
replace avggdp = avggdp/100
replace planfaced = planfaced/100
replace planmade = planmade/100

*graph bar promotion, over(year)
* promotion rate=0 in 2014; probably a data error

egen fe_provyear = group(province year)
gen growthXplan = gdpgrowth*planfaced
gen avgXplan = avggdp*planfaced
lab var growthXplan "Annual growth $\times$ target"
lab var avgXplan "Cumulative growth $\times$ target"

* for annual GDP growth, using prov-year FEs is equivalent to calculating relative GDP growth
    * gdp_rel = (gdp_it - avg_gdp_pt)
    * demeaning prov-year FE removes avg_gdp_pt
* but cumulative average is different
    * 1/2(gdp_1 + gdp_2)
    * 1/2(relgdp_1 + relgdp_2) = 1/2(gdp_1 - provgdp_1 + gdp_2 - provgdp_2)
        * = 1/2(gdp_1 + gdp_2) - 1/2(provgdp_1 + provgdp_2)
    * demeaning annually won't remove the other year

egen provgdp = mean(gdpgrowth), by(province year)
gen relgrowth = gdpgrowth - provgdp
gen relgrowthXplan = relgrowth*planfaced

sort city pos year
egen citypos = group(city pos)

bysort citypos (year): gen cumrelgrowth = sum(relgrowth)/_n
gen cumrelgrowthXplan = cumrelgrowth*planfaced

lab var relgrowth "Relative growth (annual)"
lab var cumrelgrowth "Relative growth (cumulative)"
lab var relgrowthXplan "Relative growth $\times$ target"
lab var cumrelgrowthXplan "Cumulative relative growth $\times$ target"

lab var gdpgrowth "Growth rate (annual)"
lab var avggdp "Growth rate (cumulative)"
lab var planfaced "Growth target faced"
lab var planmade "Growth target made"
lab var planmadenm "Missing growth target made"
lab var pos "Mayor/secretary FE"
lab var age "Age"
lab var age2 "Age squared"
lab var tenure "Tenure"
lab var edu "Education"

*** Linear probability model
est clear
qui: reghdfe promotion relgrowth pos age age2 tenure edu, ab(province#year) vce(cl prefcode)
eststo m1
qui: reghdfe promotion relgrowth relgrowthXplan pos age age2 tenure edu, ab(province#year) vce(cl prefcode)
eststo m2
qui: reghdfe promotion cumrelgrowth pos age age2 tenure edu, ab(province#year) vce(cl prefcode)
eststo m3
qui: reghdfe promotion cumrelgrowth cumrelgrowthXplan pos age age2 tenure edu, ab(province#year) vce(cl prefcode)
eststo m4
esttab m*, nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) order(relgrowth relgrowthXplan cumrelgrowth cumrelgrowthXplan) keep(relgrowth relgrowthXplan cumrelgrowth cumrelgrowthXplan)
esttab m* using "$root/output/li_etal/table3.tex", nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) order(relgrowth relgrowthXplan cumrelgrowth cumrelgrowthXplan) keep(relgrowth relgrowthXplan cumrelgrowth cumrelgrowthXplan)

*** Logistic regression
est clear
qui: clogit promotion relgrowth pos age age2 tenure edu, group(fe_provyear) vce(cl fe_provyear)
eststo m5
qui: clogit promotion relgrowth relgrowthXplan pos age age2 tenure edu, group(fe_provyear) vce(cl fe_provyear)
eststo m6
qui: clogit promotion cumrelgrowth pos age age2 tenure edu, group(fe_provyear) vce(cl fe_provyear)
eststo m7
qui: clogit promotion cumrelgrowth cumrelgrowthXplan pos age age2 tenure edu, group(fe_provyear) vce(cl fe_provyear)
eststo m8
esttab m*, nomtitle label replace se star(* 0.1 ** 0.05 *** 0.01) order(relgrowth relgrowthXplan cumrelgrowth cumrelgrowthXplan) keep(relgrowth relgrowthXplan cumrelgrowth cumrelgrowthXplan) eqlabels(none)
esttab m* using "$root/output/li_etal/table4.tex", nomtitle label replace se star(* 0.1 ** 0.05 *** 0.01) order(relgrowth relgrowthXplan cumrelgrowth cumrelgrowthXplan) keep(relgrowth relgrowthXplan cumrelgrowth cumrelgrowthXplan) eqlabels(none)

*** cumulative absolute growth 
* linear and logistic regression
est clear
qui: reghdfe promotion avggdp pos age age2 tenure edu, ab(province#year) vce(cl prefcode)
eststo m3
qui: reghdfe promotion avggdp avgXplan pos age age2 tenure edu, ab(province#year) vce(cl prefcode)
eststo m4
qui: clogit promotion avggdp pos age age2 tenure edu, group(fe_provyear) vce(cl fe_provyear)
eststo m7
qui: clogit promotion avggdp avgXplan pos age age2 tenure edu, group(fe_provyear) vce(cl fe_provyear)
eststo m8
esttab m* , nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) order(avggdp avgXplan) keep(avggdp avgXplan) eqlabels(none)
esttab m* using "$root/output/li_etal/table_a11.tex", nomtitle label replace se ar2 star(* 0.1 ** 0.05 *** 0.01) order(avggdp avgXplan) keep(avggdp avgXplan) eqlabels(none)

*** graph: sample size
egen mcount = count(promotion) if pos==0, by(year)
egen scount = count(promotion) if pos==1, by(year)

preserve
collapse mcount scount, by(year)

set scheme plotplainblind
lab var mcount "Mayors"
lab var scount "Secretaries"

tw (line mcount year) (line scount year) if inrange(year,2003,2014), title("") ytitle("Count") xtitle("") legend(pos(6) row(1)) 

graph export "$root/output/li_etal/fig_a1.png", replace
graph export "$root/output/li_etal/fig_a1.pdf", replace
graph export "$root/output/li_etal/fig_a1.eps", replace

restore