library(tidyverse)
library(lubridate)
library(edwr)

dir_raw <- "data/raw"
tzone <- "US/Central"
id <- "millennium.id"

dirr::gzip_files(dir_raw)

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

raw_weights <- read_data(dir_raw, "events-weight", FALSE) %>%
    as.events(order_var = FALSE) %>%
    mutate_at(vars(event.result), as.numeric) %>%
    filter(
        event.result <= 2.5,
        event.result.units == "kg"
    )

pts <- distinct(raw_weights, millennium.id)

meds_norepi <- read_data(dir_raw, "meds", FALSE) %>%
    as.meds_inpt() %>%
    semi_join(pts, by = id) %>%
    calc_runtime() %>%
    summarize_data() 

norepi_wt <- meds_norepi %>%
    inner_join(
        raw_weights[c(id, "event.datetime", "event.result")],
        by = id
    ) %>%
    filter(event.datetime < stop.datetime) %>%
    arrange(millennium.id, drip.count, event.datetime) %>%
    distinct(millennium.id, .keep_all = TRUE)
