---
title: "README"
author: "Andrew Pederson"
date: "2022-09-08"
output: html_document
---

# Evaluating Service Quality vs. Revenue and Spending Between U.S. States

This analysis was inspired by a 2021 WalletHub analysis that purported to show a 'tax ROI' between states. That is, a comparison between the amount of taxes paid and the quality of services received. This project began as an experiment to statistically evaluate the WalletHub analysis and expand it by using U.S. Census data on state tax revenues as well as state and local expenditures on different service areas to explore those relationships.

This project found no significant statistical relationship between partisan control and service quality and also prompted questions about the original methodology. These questions provide a solid basis for reinterpreting the original measurement indicators and experimenting with new ways to gauge the efficacy and effectiveness of government spending as it relates to specific citizen outcomes.

The final report is in this directory as a .pdf file generated from 'State_Performance_Party.Rmd', and the raw data files are the in ./data directory. The 'Data_Clean_Munge.py' script was used to acquire, clean, format and output data files, and the 'state_ranks_analysis.R' script was used to conduct the statistical analyses and create visualizations.

# Data Sources

-   WalletHub state tax ROI from <https://wallethub.com/edu/state-taxpayer-roi-report/3283>
-   Party control of the Legislature and Governorship in 2020 was manually input from <https://ballotpedia.org/State_legislative_elections,_2020> and <https://ballotpedia.org/Election_results,_2020:_Partisan_balance_of_governors>
-   Tax Burden data from <https://taxfoundation.org/tax-burden-by-state-2022/>
-   2020 population estimates from the US Census API from <http://api.census.gov/data/2021/pep/population>
-   Census data on state and local taxes and expenditures from <https://www.census.gov/data/datasets/2020/econ/local/public-use-datasets.html>. The two Excel files were combined to include all states.
-   National Assessment of Educational Progress (NAEP) test scores for most recent available year from <https://www.nationsreportcard.gov/profiles/stateprofile>
-   National Center for Education Statistics student enrollment data from <https://nces.ed.gov/programs/digest/d22/tables/dt22_203.20.asp> \_
-   CDC life expectancy data from <https://www.cdc.gov/nchs/pressroom/sosmap/life_expectancy/life_expectancy.htm>
-   CDC infant mortality data from <https://www.cdc.gov/nchs/pressroom/sosmap/infant_mortality_rates/infant_mortality.htm>
-   CDC obesity data from <https://www.cdc.gov/obesity/data/prevalence-maps.html>
