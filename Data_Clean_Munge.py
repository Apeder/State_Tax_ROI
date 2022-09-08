import pandas as pd
import requests

## Downloaded Census data on state and local taxes and expenditures from https://www.census.gov/data/datasets/2020/econ/local/public-use-datasets.html and combined the two files to include all states.

## Create list to skip blank and unneeded rows
skps = list(range(0,9))+list(range(10,15))+list(range(41,80))+list(range(90,97))+[16,18,23,39,98,100,102,105,106,112,116,117,119,123,124,130,131,133,135,138,140,141,142,]
skps.sort()

## Read Excel file, excluding unneeded columns and rows, into the 'state_local_revs_expns_2020' dataframe object. This limits the dataset to Fiscal Year 2020 values from all 50 states. The 36 observations comprise Total Revenue, General Revenue, Intergovernmental Revenue, Taxes, General Sales, Selective Sales, License Taxes, Individual Income Tax, Corporate Income Tax and a breakdown of individual expenditure areas. All amounts are in thousands of dollars.

state_local_revs_expns_2020 = pd.read_excel('./data/2020_State_Local_Revs_Expns.xlsx', usecols='B,H,M,R,W,AB,AG,AL,AQ,BA,BF,BK,BP,BU,BZ,CE,CJ,CO,CT,CY,DD,DI,DN,DS,DX,EC,EH,EM,ER,EW,FB,FG,FL,FQ,FV,GA,GF,GK,GP,GU,GZ,HE,HJ,HO,HT,HY,ID,II,IN,IS,IX', skiprows=skps, skipfooter=53).transpose()

## Reset observation labels to column names and reindex. Convert datatypes into integer or string where appropriate and strip whitespaces. Rename 'index' column to 'State' and remove 'thousands of dollars' as column object name. 
state_local_revs_expns_2020.columns = state_local_revs_expns_2020.iloc[0].str.strip().str.replace(' ', '_', regex=False)
state_local_revs_expns_2020 = state_local_revs_expns_2020.iloc[1:].reset_index().convert_dtypes()
state_local_revs_expns_2020.rename(columns={"index":"State","Health":"Health_Expenditures","Education":"Education_Expenditures","Public_welfare":"Public_Welfare_Expenditures","Hospitals":"Hospital_Expenditures","Highways":"Highway_Expenditures","Police_protection":"Police_Expenditures","Correction":"Corrections_Expenditures","Natural_Resources":"Natural_Resources_Expenditures", "Natural_resources":"Natural_Resources_Expenditures","Parks_and_recreation":"Parks_Rec_Expenditures","Governmental_administration":"Govt_Admin_Expenditures"}, inplace=True)
state_local_revs_expns_2020.columns.name = None

## Read in ranks file from https://wallethub.com/edu/state-taxpayer-roi-report/3283 to merge with revenue and expenditure data. Party control of the Legislature and Governorship in 2020 was manually input from https://ballotpedia.org/State_legislative_elections,_2020 and https://ballotpedia.org/Election_results,_2020:_Partisan_balance_of_governors
ranks = pd.read_csv('./data/State_Rankings.csv').convert_dtypes()
ranks.rename(columns={"Revenue1":"Total_Revenue","" "Health":"Health_Score","Overall Gov’t. Services Rank":"Overall_Rank","Total Score":"Total_Score","Education":"Education_Score","Safety":"Safety_Score","Economy":"Economy_Score","Infrastructure & Pollution":"Infra_Pollution_Score","2020 Vote":"Vote_2020"}, inplace=True)

state_ranks_tax_ROI_2020 = ranks.merge(state_local_revs_expns_2020, on='State')

## Retrieve tax brurden data for 2020 from tax foundation website and clean it
tax_burd = pd.read_html(requests.get('https://taxfoundation.org/tax-burden-by-state-2022/').content)[2]
tax_burd.columns = tax_burd.columns.droplevel(0).to_flat_index()
tax_burd.columns=[''.join(x) for x in tax_burd.columns]
tax_burd.rename(columns={'Unnamed: 0_level_1State':'State','2020Rate':'2020_Tax_Burden'}, inplace=True)

# Add tax burden column to dataframe
state_ranks_tax_ROI_2020 = pd.merge(state_ranks_tax_ROI_2020,tax_burd[['State','2020_Tax_Burden']],on='State', how='left')

# Retrieve 2020 population estimates from the US Census API
req = requests.get('http://api.census.gov/data/2021/pep/population?get=NAME,POP_2020&for=state:*&key=secret_key')
pop_2020 = pd.read_json(req.text)
pop_2020.columns = pop_2020.iloc[0]
pop_2020.rename(columns={'NAME':'State','state':'num'}, inplace=True)
pop_2020.drop(pop_2020.index[0], inplace=True)

# Add population to dataframe
state_ranks_tax_ROI_2020 = pd.merge(state_ranks_tax_ROI_2020,pop_2020[['State','POP_2020']],on='State', how='left')

# Write dataframe to .csv for analysis and visualization in R
state_ranks_tax_ROI_2020.to_csv('./data/Ranks_Tax_ROI_2020_State_local.csv')
