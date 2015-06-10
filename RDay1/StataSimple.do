clear all 
set more off 
version 12.1
//change this next line as necessary
cd C:\Users\garret\Documents\Research\BITSS\WorkshopSlides\BITSS2015Summer

insheet using ratings.csv
tab class
gen plant=(class=="plant")

*OUTPUT IN TEX
ssc install outreg2 //Make sure you have outreg2 installed
reg meansizerating frequency plant meanweightrating deriventropy
outreg2 using outputS.tex, tex replace bdec(3) tdec(3)
gen frequency_x_plant=frequency*plant
reg meansizerating frequency plant meanweightrating deriventropy frequency_x_plant
outreg2 using outputS.tex, tex append bdec(3) tdec(3)
reg meansizerating frequency plant meanweightrating deriventropy frequency_x_plant, robust
outreg2 using outputS.tex, tex append bdec(3) tdec(3)

