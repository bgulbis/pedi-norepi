library(tidyverse)
library(lubridate)
library(edwr)

dir_raw <- "data/raw"
tzone <- "US/Central"
id <- "millennium.id"

# run MBO query
#   * Patients - by Medication (Generic) - Location
#       - Facility (Curr): HC Childrens
#       - Admit Date: 7/1/2017 - 6/30/2018
#       - Medication (Generic): norepinephrine
#       - Nurse Unit (Med): HC PICU;HC NICE;HC NICW;HC A8N4;HC A8NH

potential_pts <- read_data(dir_raw, "patients", FALSE) %>%
    as.patients()

mbo_id <- concat_encounters(potential_pts$millennium.id)

# run MBO queries
#   * Clinical Events - No Order Id - Prompt
#       - Clinical Event: Weight;Current Weight
#   * Medications - Inpatient - Prompt
#       - Medication (Generic): norepinephrine

meds_norepi <- read_data(dir_raw, "meds", FALSE) %>%
    as.meds_inpt() %>%
    calc_runtime() %>%
    summarize_data()

raw_weights <- read_data(dir_raw, "events-weight", FALSE) %>%
    as.events(order_var = FALSE) 

