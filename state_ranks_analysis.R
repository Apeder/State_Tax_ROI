library(ggplot2)
library(readr)
library(ggrepel)

# Read in WalletHub dataset with partisan control variables added
ranks <- read.csv('./data/State_Rankings.csv', stringsAsFactors = TRUE)

# Look at distribution of scores
hist(ranks$Total.Score)

# Test score distribution for normality - some outliers at the edges, though normal enough
shapiro.test(ranks$Total.Score)
qqnorm(ranks$Total.Score)

# Test if scores are significantly different between groups that voted either for the Republican or Democratic presidential candidate in 2020
# There is a statistically significant difference between the overall ROI scores - 55.8 in Dem voting vs. 49.48 in Rep voting
t.test(ranks$Total.Score~ranks$X2020.Vote)

# Visualize the difference in scores by party presidential vote in 2020
ggplot(ranks,aes(x=Total.Score,group=X2020.Vote,fill=X2020.Vote))+
  geom_density(alpha=0.5)+theme_bw() + scale_fill_manual( values = c("blue","red"))

# Examine legislative control's relationship with total service quality score
# Analysis of Variance indicates a significant relationship
anova(lm(ranks$Total.Score~ranks$Legislature))

# Linear model shows no significant (p<.05) relationships, however
summary(lm(ranks$Total.Score~ranks$Legislature))

# Pairwise t text shows significant difference between Republican and split legislatures (p=.05)
pairwise.t.test(ranks$Total.Score, ranks$Legislature)

# Tukey test confirms significant difference between S and R legislature states, though there are only two split legislatures. 
TukeyHSD(aov(ranks$Total.Score~ranks$Legislature))

# Visualize the above data
ggplot(ranks,aes(x=Total.Score,group=Legislature,fill=Legislature))+
  geom_density(alpha=0.5)+theme_bw() + scale_fill_manual( values = c("blue","red","orange"))

# Test for significant difference based on overall government control
# ANOVA results in no significant relationship
anova(lm(ranks$Total.Score~ranks$Control))
TukeyHSD(aov(ranks$Total.Score~ranks$Control))

# Visualize the above - distributions have significant overlap and are very likely the same population.
ggplot(ranks,aes(x=Total.Score,group=Control,fill=Control))+
  geom_density(alpha=0.5)+theme_bw() + scale_fill_manual( values = c("blue","red","orange"))

# Read in .csv with tax foundation tax burden and census tax/revenue data
st_ROI_holist <- read.csv('./data/Ranks_Tax_ROI_2020_State_local.csv') 
st_ROI_holist$X2020_Tax_Burden <- parse_number(st_ROI_holist$X2020_Tax_Burden)

st_ROI_holist$ST <- state.abb

# Add National Assessment of Educational Progress test scores from most recent available year downloaded from
# https://www.nationsreportcard.gov/profiles/stateprofile
test_scores <- read.csv('./data/NAEP_Math_Reading_Scores_2019.csv')
st_ROI_holist$Eigth_math_scores <- test_scores$NAEP_Math_2019
st_ROI_holist$Eigth_read_scores <- test_scores$NAEP_Reading_2019

# Add student enrollment data from National Center for Education Statistics downloaded from
# https://nces.ed.gov/programs/digest/d22/tables/dt22_203.20.asp
num_students <- read.csv('./data/state_student_enrollment.csv')
st_ROI_holist$num_stdnts_2020 <- parse_number(num_students$Fall.2020)

# Calculate total state/local expenditures per student
st_ROI_holist$ed_spend_per_stdt <- st_ROI_holist$Elementary_._secondary/st_ROI_holist$num_stdnts_2020

# Create generic plotting function
tax_plot <- function(x,y,x_title,y_title) {

  graph <- ggplot(st_ROI_holist, aes(x={{x}},y={{y}},label=ST))+
    geom_point(aes(color=Control,size=POP_2020/1000000))+
    scale_color_manual(values=c("blue","red","orange"))+
    geom_text_repel(size=2)+
    geom_smooth(method='lm')+
    theme_bw()+
    theme(legend.title=element_text(size=8))+
    labs(x=x_title,y=y_title, size="Population\n(millions)")
  
  return(graph)
}

# Examine relationship between tax burden and WalletHub's overall service quality score
# Seems to show strong linear correlation between tax burden and total score
tax_plot(X2020_Tax_Burden,Total_Score,"2020 Tax Burden (%)","WalletHub Total Service Quality Score")

#ANOVA confirms strong relationship                                                                        
anova(lm(st_ROI_holist$Total_Score~st_ROI_holist$X2020_Tax_Burden))

# Linear model indicates that higher tax burdens are correlated with higher service
# quality scores (p=.0001)
summary(lm(st_ROI_holist$Total_Score~st_ROI_holist$X2020_Tax_Burden))

# Republican states do have lower tax burdens
anova(lm(st_ROI_holist$X2020_Tax_Burden~st_ROI_holist$Control))
summary(lm(st_ROI_holist$X2020_Tax_Burden~st_ROI_holist$Control))
pairwise.t.test(st_ROI_holist$X2020_Tax_Burden, st_ROI_holist$Control)
TukeyHSD(aov(st_ROI_holist$X2020_Tax_Burden~st_ROI_holist$Control))

# Are better scores associated with more spending? No.
tax_plot(Direct_expenditure/POP_2020,Total_Score,"State/Local Expenditures per Capita 2020","Total Score")

anova(lm(st_ROI_holist$Total_Score~st_ROI_holist$Direct_expenditure))

# Does spending per student matter? Very weird negative correlation with WalletHub data
# Same whether we look at expenditures per capita or just for primary/secondary students
tax_plot(ed_spend_per_stdt,Education_Score,"State/Local Primary and Secondary Education Expenditures","Education Score")

# Education spend per student is associated with higher test scores.
tax_plot(ed_spend_per_stdt,Eigth_math_scores,"State/Local Primary and Secondary Education Expenditures 
         per Enrolled Student","NAEP 2019 8th Grade Average Math Score")

tax_plot(ed_spend_per_stdt,Eigth_read_scores,"State/Local Primary and 
         Secondary Education Expenditures per Enrolled Student","NAEP 2019 8th Grade Average Reading Score")

anova(lm(st_ROI_holist$Eigth_math_scores~st_ROI_holist$ed_spend_per_stdt))

# Greater spend per student associated with higher test scores, math p=.01
summary(lm(st_ROI_holist$Eigth_math_scores~st_ROI_holist$ed_spend_per_stdt))
# Reading p=.0047
summary(lm(st_ROI_holist$Eigth_read_scores~st_ROI_holist$ed_spend_per_stdt))

# No significant relationship between party control, at least in 2020
anova(lm(st_ROI_holist$Eigth_math_score~st_ROI_holist$Control))

# Health
# No siginificant relationship between per capita health spending and wallethub's scores
tax_plot(Health_Expenditures/POP_2020,Health_Score,"State/Local per Capita Health Expenditures", "Health Score")

health_percap <- st_ROI_holist$Health_Expenditures/st_ROI_holist$POP_2020
anova(lm(st_ROI_holist$Health_Score~health_percap))

# Life Expectancy
# Read in life expectancy data from CDC https://www.cdc.gov/nchs/pressroom/sosmap/life_expectancy/life_expectancy.htm
life_expect <- read.csv('./data/st_life_expectancy_2020.csv')
st_ROI_holist$life <- life_expect[1:50,3]

tax_plot(Health_Expenditures/POP_2020,life,"State/Local per Capita Health Expenditures 2020","Average Life Expectancy")

anova(lm(st_ROI_holist$life~health_percap))
summary(lm(st_ROI_holist$life~health_percap))

# Infant Mortality
# Read infant mortality data from CDC https://www.cdc.gov/nchs/pressroom/sosmap/infant_mortality_rates/infant_mortality.htm
inf_mort <- read.csv('./data/inf_mort_2020.csv')
st_ROI_holist$inf_mort <- as.numeric(inf_mort[1:50,3])

tax_plot(Health_Expenditures/POP_2020,inf_mort,"State/Local per Capita Health Expenditures 2020","Infant Mortality")

anova(lm(st_ROI_holist$inf_mort~health_percap))
summary(lm(st_ROI_holist$inf_mort~health_percap))

# Obesity
# Read obesity data from CDC https://www.cdc.gov/obesity/data/prevalence-maps.html
obesity <- read.csv('./data/obesity_2020.csv')
obese <- subset(obesity, State!="District of Columbia" & State!="Guam" & State!="Puerto Rico" )
st_ROI_holist$obesity <- obese$Prevalence

tax_plot(Health_Expenditures/POP_2020,obesity,"State/Local per Capita Health Expenditures 2020","Obesity")

anova(lm(st_ROI_holist$obesity~health_percap))
summary(lm(st_ROI_holist$obesity~health_percap))
