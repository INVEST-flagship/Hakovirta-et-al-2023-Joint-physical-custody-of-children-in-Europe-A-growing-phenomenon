*******************************************************
*STATA COMMANDS FOR THE PAPER "Joint physical custody of children in Europe: A growing phenomenon"
*******************************************************
*CONTENTS:

*1. CREATING THE "2021_cross_eu_silc.dta" DATA FILE
*
*	1.1. Convert the personal register ("the R-file"), the personal data ("the P-file"), the household register ("the D-file") and the household data ("the H-file") .csv-files to Stata readable .dta-format.
*		-In the end you will have 4 separate R-, P-, D-and H-files containing data from all countries for the year 2021
*		-Please consult the "Methodological guidelines and description of EU-SILC target variables"-document for more information on how Eurostat delivers the EU-SILC microdata. Available here: https://circabc.europa.eu/sd/a/f8853fb3-58b3-43ce-b4c6-a81fe68f2e50/Methodological%20guidelines%202021%20operation%20v4%2009.12.2020.pdf (Accessed 13.2.2023)
*	1.2. Create key variables for merging the R-, P-, D-and H-files
*	1.3. Combine the the R-, P-, D-and H-files to one .dta file ("2021_cross_eu_silc.dta") that will be used for the analysis
*
*2. PRODUCING VARIABLES AND ESTIMATES FOR THE ANALYSIS

***
*Note: Stata commands for the data file and analysis were produced with Stata version 17 and may not be compatible with earlier versions.
***

*******************************************************
1. CREATING THE "2021_cross_eu_silc.dta" DATA FILE
*******************************************************
*1.1. Convert the R-, P-, D-and H-files provided in .csv format to .dta-files
*******************************************************

*The following command should contain the complete path where the CSV data files are stored
*Change CSV_PATH to your file path (e.g.: C:/EU-SILC/Crossectional 2004-2019) 
*Use forward slashes and keep path structure as delivered by Eurostat CSV_PATH/COUNTRY/YEAR

global csv_path "C:/EU-SILC/Crossectional 2021/CSV" 

******

*PERSONAL REGISTER FILE (the R-file)

*Create a loop that opens each country .csv-file in Stata and appends them together one by one
*The resulting file contains information on all individuals in the R-file and from all countries for the year 2021
clear all
tempfile temp 
save `temp', emptyok 

foreach CC in AT BE BG CY CZ DE DK EE EL ES FI FR HR HU IE IT LT LU LV MT NL PT RO SE SI { 
      cd "$csv_path/`CC'/2021" 
	  import delimited using "UDB_c`CC'21R.csv", case(upper) asdouble clear 
	  append using `temp', force 
save `temp', replace  
} 

label data "Personal register file 2021" 

compress 
save "C:/EU-SILC/Crossectional 2021/2021_cross_eu_silc_p_reg.dta", replace


******
*PERSONAL DATA FILE (the P-file)

*Create a loop that opens each country .csv-file in Stata and appends them together one by one
*The resulting file contains information on all individuals in the P-file and from all countries for the year 2021
clear all
tempfile temp 
save `temp', emptyok 

foreach CC in AT BE BG CY CZ DE DK EE EL ES FI FR HR HU IE IT LT LU LV MT NL PT RO SE SI { 
      cd "$csv_path/`CC'/2021" 
	  import delimited using "UDB_c`CC'21P.csv", case(upper) asdouble clear 
	  append using `temp', force 
save `temp', replace  
} 

label data "Personal data file 2021" 

compress 
save "C:/EU-SILC/Crossectional 2021/2021_cross_eu_silc_p_data.dta", replace 


******
*HOUSEHOLD REGISTER FILE (the D-file)

*Create a loop that opens each country .csv-file in Stata and appends them together one by one
*The resulting file contains information on all households in the D-file and from all countries for the year 2021
clear all
tempfile temp 
save `temp', emptyok 

foreach CC in AT BE BG CY CZ DE DK EE EL ES FI FR HR HU IE IT LT LU LV MT NL PT RO SE SI { 
      cd "$csv_path/`CC'/2021" 
	  import delimited using "UDB_c`CC'21D.csv", case(upper) asdouble clear 
	  append using `temp', force 
save `temp', replace  
} 

label data "Household register file 2021" 

compress 
save "C:/EU-SILC/Crossectional 2021/2021_cross_eu_silc_hh_reg.dta", replace 


******
*HOUSEHOLD DATA FILE (the H-file)

*Create a loop that opens each country .csv-file in Stata and appends them together one by one
*The resulting file contains information on all households in the H-file and from all countries for the year 2021
clear all
tempfile temp 
save `temp', emptyok 

foreach CC in AT BE BG CY CZ DE DK EE EL ES FI FR HR HU IE IT LT LU LV MT NL PT RO SE SI { 
      cd "$csv_path/`CC'/2021" 
	  import delimited using "UDB_c`CC'21H.csv", case(upper) asdouble clear 
	  append using `temp', force 
save `temp', replace  
} 

label data "Household data file 2021" 

compress 
save "C:/EU-SILC/Crossectional 2021/2021_cross_eu_silc_hh_data.dta", replace 


*******************************************************
*1.2. Create key variables for merging the R-, P-, D-and H-files
*******************************************************

*Create the key variables in each file by using the following variables in the R-, P-, D-and H-files:
*(The first letter of each variable indicates whether it is present in either R-, P-, D-or H-file)

*year (PB010, RB010, HB010, DB010)
*country (PB020, RB020, HB020, DB020)
*hh_id (PX030, RX030, HB030, DB030 
*per_id (PB030, RB030)

*PERSONAL DATA FILE (the P-file)
clear all
use "$path/2021_cross_eu_silc_p_data.dta" 
clonevar year=PB010 
clonevar country=PB020 
clonevar per_id=PB030 
clonevar hh_id=PX030 
sort year country hh_id per_id 
save "$path/2021_cross_eu_silc_p_data.dta", replace  

*PERSONAL REGISTER FILE (the R-file)
use "$path/2021_cross_eu_silc_p_reg.dta", clear 
clonevar year=RB010 
clonevar country=RB020 
clonevar per_id=RB030 
clonevar hh_id=RX030 
sort year country hh_id per_id 
save "$path/2021_cross_eu_silc_p_reg.dta", replace  


*HOUSEHOLD DATA FILE (the H-file)
use "$path/2021_cross_eu_silc_hh_data.dta", clear 
clonevar year=HB010 
clonevar country=HB020 
clonevar hh_id=HB030 
sort year country hh_id 
save "$path/2021_cross_eu_silc_hh_data.dta", replace  


*HOUSEHOLD REGISTER FILE (the D-file)
use "$path/2021_cross_eu_silc_hh_reg.dta", clear 
clonevar year=DB010 
clonevar country=DB020 
clonevar hh_id=DB030 
sort year country hh_id 
save "$path/2021_cross_eu_silc_hh_reg.dta", replace  



*******************************************************
*1.3. Combine the the R-, P-, D-and H-files to one .dta file ("2021_cross_eu_silc.dta")
*******************************************************

*First, merge household level data files i.e. the D-and H-files together with the corresponding variables "year", "country" and "hh_id"
*Drop households that are not present in the D-file

use "$path/2021_cross_eu_silc_hh_reg.dta", clear 
merge 1:1 year country hh_id using "$path/2021_cross_eu_silc_hh_data.dta"  
drop if _merge==2 
drop _merge 

*Second, add individual level data from the R-file to the household file created above. Use variables "year", "country" and "hh_id" to find corresponding households for each individual.
*Drop individuals from the R-file that do not have household level information

merge 1:m year country hh_id using "$path/2021_cross_eu_silc_p_reg.dta" 
drop if _merge==2 
drop _merge 

*Last, add individual level data from the P-file to the rest of the data. Use variables "year", "country", "hh_id" and "per_id" to connect individuals in the P-file to their households and to information about themselves already present in the data.
*Drop individuals from the P-file that do not have any other information about them in the rest of the data

merge 1:1 year country hh_id per_id using "$path/2021_cross_eu_silc_p_data.dta"  
drop if _merge==2 
drop _merge 
label data "Cross-sectional data file 2021"
save "$path/2021_cross_eu_silc.dta", replace  




*******************************************************
*2. PRODUCING VARIABLES AND ESTIMATES FOR THE ANALYSIS
*******************************************************

*Creating the variable identifying children aged 0 to 17 years

recode RX010 (0/17=1) (else=.), gen (child)

*Creating the 3-category physical custody variable

recode RK070 (0/9=1 "Sole") (10/14=2 "Unequal share") (15=3 "Equal share") (16/20=2 "Unequal share") (21/31=1 "Sole") (else=.), gen(sh3cat_33)
label variable sh3cat_33 "3-category shared care separating equal, unequal and sole with 33 % criteria"

*Creating the 4-category variable of child's age

recode RX010 (0/5=1 "0-5 years old") (6/10=2 "6-10 years old") (11/15=3 "11-15 years old") (16/17=4 "16-17 years old") (else=.), gen(age_child4)
label variable age_child4 "4-category child's age"

*Creating the variable to include 17 countries with no data problems

gen include=.
replace include=1 if country=="AT"
replace include=1 if country=="BE"
replace include=1 if country=="CY"
replace include=1 if country=="CZ"
replace include=1 if country=="DK"
replace include=1 if country=="EE"
replace include=1 if country=="EL"
replace include=1 if country=="ES"
replace include=1 if country=="FI"
replace include=1 if country=="FR"
replace include=1 if country=="HR"
replace include=1 if country=="HU"
replace include=1 if country=="IT"
replace include=1 if country=="LT"
replace include=1 if country=="RO"
replace include=1 if country=="SE"
replace include=1 if country=="SI"

*Excluding countries with data problems

drop if include==.

*Crosstab with country and physical custody arrangement (including only children aged 0-17 who are household members but have a parent residing outside of the household)

tab country sh3cat_33 if child==1 & RK010==., row chi2

*With weights

tab country sh3cat_33 [aw=RB050] if child==1 & RK010==., row

*Crosstab with child's age and physical custody (including only children aged 0-17 who are household members but have a parent residing outside of the household)

tab age_child4 sh3cat_33 if child==1 & RK010==., row chi2

*With weights

tab age_child4 sh3cat_33 [aw=RB050] if child==1 & RK010==., row

*Crosstab with child's age and physical custody by country (including only children aged 0-17 who are household members but have a parent residing outside of the household)

by country, sort: tab age_child4 sh3cat_33 if child==1 & RK010==., row chi2

*With weights

by country, sort: tab age_child4 sh3cat_33 [aw=RB050] if child==1 & RK010==., row




