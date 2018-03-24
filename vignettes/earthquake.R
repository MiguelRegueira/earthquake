## ---- echo = FALSE-------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.path = "README-"
)

## ----install-------------------------------------------------------------
require(devtools)
devtools::install_github('eregmig/earthquake', build_vignettes = TRUE)
library(earthquake)

## ----load_data-----------------------------------------------------------
library(dplyr)
library(lubridate)
data <- eq_clean_data()

## ----timeline------------------------------------------------------------
library(ggplot2)
data %>% 
  dplyr::filter(COUNTRY %in% c("GREECE", "ITALY")) %>%
  ggplot(aes(x = DATE, y = COUNTRY, color = TOTAL_DEATHS, size = EQ_PRIMARY, magnitude = EQ_PRIMARY, label = LOCATION_NAME)) +
  geom_timeline_label(xmin = "2000-01-01", xmax = "2010-01-01", n_max = 2, angle = 60) +
  geom_timeline(xmin = "2000-01-01", xmax = "2010-01-01") +
  theme_timeline()

## ----map-----------------------------------------------------------------
library(leaflet)
data %>% dplyr::filter(COUNTRY == "SPAIN") %>%
  dplyr::mutate(POPUP = eq_create_label(.)) %>%
  eq_map(annot_col = "POPUP")

