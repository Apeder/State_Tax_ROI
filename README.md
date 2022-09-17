---
title: "README"
author: "Andrew Pederson"
date: "2022-09-08"
output: html_document
---

# Evaluating Service Quality vs. Revenue and Spending Between U.S. States

This analysis was inspired by a 2021 WalletHub analysis that purported to show a 'Tax ROI' between states. That is, a comparison between the amount of taxes paid and the quality of services received. This project began as an attempt to sense check the WalletHub analysis and expand it by using U.S. Census data on state tax revenues as well as state and local expenditures on different service areas. 

This project found no significant statistical results to establish partisan control as a predictor for service quality and also raised questions about the original methodology. As well, the questions raised provide a solid basis for reinterpreting these measurement indicators and experimenting with new ways to gauge the efficiacy and effectiveness of government spending as it relates to discrete citizen outcomes. 

The final report is in this directory as both a .pdf and .html file generated from 'State_Performance_Party.Rmd', and the raw data files are the in ./data directory. The 'Data_Clean_Munge.py' script was used to acquire, clean, format and output data files, and the 'state_ranks_analysis.R' script was used to conduct the statistically analyses and create visualizations. 

# Development Setup

**Prerequisites:**
  - Python 3.x (for generating data)
  - [R](https://mirror.las.iastate.edu/CRAN/)

## Python environment setup for data generation

The following steps are recommended for running `Data_Clean_Munge.py`.

1. Create a new virtual environment (in a local directory called `venv` at the project top-level):

        python -m venv venv
2. Activate the virtual environment:

         source ./venv/bin/activate
3. Install project dependencies:

         pip install -r requirements.txt

## R setup for report processing and statistical analysis


