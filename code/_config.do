* Ensure Stata uses only local libraries and programs
* All required Stata packages are available in code/libraries/stata

tokenize `"$S_ADO"', parse(";")
while `"`1'"' != "" {
  if `"`1'"'!="BASE" cap adopath - `"`1'"'
  macro shift
}
adopath ++ "$root/code/libraries/stata"

* load programs
include "$root/code/libraries/stata/p/PanelCombine.do" 

* create directories
cap mkdir "$root/output"
cap mkdir "$root/output/chen_kung"
cap mkdir "$root/output/li_etal"
cap mkdir "$root/output/yao_zhang"