This repository contains Stata .do files and datasets needed for replicating the results in "[Replicating the literature on prefecture-level meritocratic promotion in China](https://michaelwiebe.com/assets/promotion)".
This paper reanalyzes [Yao and Zhang (2015)](https://link.springer.com/article/10.1007/s10887-015-9116-1), [Li et al. (2019)](https://academic.oup.com/ej/article-abstract/129/623/2888/5492257), and [Chen and Kung (2019)](https://academic.oup.com/qje/article/134/1/185/5140154). 

To replicate the results, run the file `run.do` using Stata (version 16).
Edit line 2 in `run.do` to set the path to the folder containing this README.
You should expect the code to run for 2 hours.
Required Stata packages are included in 'code/libraries/stata/'; the user does not have to download anything and the replication can be run offline.

The directory 'code/' contains three subdirectories (one for each paper) with data and code to carry out my reanalyses.
The data is from the corresponding replication packages of the three papers.
Figures and tables are saved in 'output/'; that directory is created by `code/_config.do`.

The Chen and Kung (2019) directory contains the original data (prefecture_panel.dta), raw leader-level data obtained from James Kung (prefecture_leaders.dta), and the promotion data from Wiebe (2020) (promotion_wiebe.dta). 
The Li et al. (2019) directory contains the original data but with corrected column headers (promotion.csv). 
The Yao and Zhang (2015) directory contains the original data (Leader_Growth.dta) as well as a dataset produced from the original code (Leader_Growth_logsc.dta).
Each directory also contains a dataset, derived from the original, with only the promotion variables; these are used to compare the promotion rates across datasets (promotion_ck.dta, promotion_li.dta, promotion_yz.dta).
