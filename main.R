# main.R Runs all construction, analysis, scoping, presentation etc for 'dual process' project, at least the Omnibus-linked experiment 

##############################
# Setup 

#install.packages("checkpoint")
library(checkpoint)

library(here)
library(knitr)
library(haven)
library(tidyverse)
library(codebook)

here <- here::here

setwd(here())

#### Usual options and some handy functions
# This sources the code I share across projects:

source_url('https://raw.githubusercontent.com/daaronr/dr-rstuff/master/functions/baseoptions.R')

source_url('https://raw.githubusercontent.com/daaronr/dr-rstuff/master/functions/functions.R')

########################
# Import and varlists 

purl(here("analysis","ImportData.Rmd"), output = here("code","ImportData.R")) 

source(here("code","ImportData.R"))

source(here("code","varlists.R"))

#####################################################################
# Produce codebooks for each experiment (takes a long time to run!)
#(when we put these online, we can have these imported using 'rio' from a url)

n <- readline("Codebooks take a long time to run. Are you sure you want to run these? (Y/N)")

if (n=="Y") {
  print("OK, be patient...")
  rmarkdown::render(here("analysis",'codebook_DP.Rmd'))
}

#############################
# main analysis of data (WIP)
rmarkdown::render('analysis/analysis_dp.Rmd')

#############################

#############################
## Implementation work, not for analysis:
rmarkdown::render(here("admin_prereg_misc","payment_processing.Rmd"))

#############################
## Associated presentations
# build presentation/DV_impact_present.rmd (simpler)
# build presentation/SPI_EA_impact.Rmd (more informati)

# Now for DonorVoice trials -- BOOKDOWN it?
# see dv_input_anal.Rmd