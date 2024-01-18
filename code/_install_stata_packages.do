*******
* This script installs all necessary Stata packages into /libraries/stata
* To do a fresh install of all Stata packages, delete the entire /libraries/stata folder
* Note: this script has been provided for pedagogical purposes only. It should NOT be included as part of your replication materials, since these add-ons are already available in /libraries/stata
*******

* Create and define a local installation directory for the packages
cap mkdir "$root/code/libraries"
cap mkdir "$root/code/libraries/stata"
net set ado "$root/code/libraries/stata"

* Install packages from SSC
foreach p in tsspell blindschemes estout cmp ghk2 {
	local ltr = substr(`"`p'"',1,1)
	qui net from "http://fmwww.bc.edu/repec/bocode/`ltr'"
	net install `p', replace
}
*  gtools  winsor2 coefplot spmap shp2dta

* Install ftools (remove program if it existed previously)
cap ado uninstall ftools
net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/")

* Install reghdfe
cap ado uninstall reghdfe
net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")

/* * https://github.com/sergiocorreia/ivreghdfe#installation
    * follow this order
* Install ftools (remove program if it existed previously)
cap ado uninstall ftools
net install ftools, from("https://raw.githubusercontent.com/sergiocorreia/ftools/master/src/")

* Install reghdfe
cap ado uninstall reghdfe
net install reghdfe, from("https://raw.githubusercontent.com/sergiocorreia/reghdfe/master/src/")

* Install ivreg2, the core package
cap ado uninstall ivreg2
ssc install ivreg2

* Finally, install this package
cap ado uninstall ivreghdfe
net install ivreghdfe, from(https://raw.githubusercontent.com/sergiocorreia/ivreghdfe/master/src/)
*/

* multi-panel latex tables
cap mkdir "$root/code/libraries/stata/p"
* create directory if it doesn't exist
shell wget -P $root/code/libraries/stata/p/ https://raw.githubusercontent.com/steveofconnell/PanelCombine/master/PanelCombine.do
* note: put `include "$root/code/libraries/stata/p/PanelCombine.do"` in _config.do, to define the program within the Stata instance

***
***
*** note: felsdvreg is not available? 
* have to copy ado files from old repo