* set path: uncomment the following line and set the filepath for the folder containing this run.do file
*global root "[location of replication archive]"
global code "$root/code"

clear
set more off

* Stata version control
version 16

* configure library environment
do "$code/_config.do"

cap log close
log using "$root/output/log.txt", text replace

do "$code/ck_replication/chen_kung.do"
do "$code/li_etal_replication/li_etal.do"
do "$code/yz_replication/yao_zhang.do"

log close