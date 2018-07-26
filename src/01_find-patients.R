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

