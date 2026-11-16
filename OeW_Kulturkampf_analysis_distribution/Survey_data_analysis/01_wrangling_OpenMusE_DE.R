# 01_wrangling_OpenMusE_DE.R
# OpenMusE German CAWI analysis

library(haven)
library(dplyr)
library(stringr)

# Edit data path as needed
data_path <- "inputs/OpenMusE_T3.2_CAP_CAWI_clean_analysis_postcode_enriched.sav"

cawi_raw <- read_sav(data_path)

# Variables required for the current analysis.
# sample1 is retained because sample1 == 2 defines the German Block B sample.
cawi_de <- cawi_raw %>%
  select(
    S0,
    S2_REC,
    S3,
    S4,
    starts_with("M57"),
    M59,
    starts_with("M61"),
    starts_with("M62"),
    starts_with("M63"),
    M63b_DE,
    wDemo_v1,
    filter_main_DE,
    sample1
  ) %>%
  filter(sample1 == 2)

# Preserve SPSS-labelled analysis data.
cawi_de_labelled <- cawi_de

# Basic checks.
cat("German Block B analysis sample (sample1 == 2):\n")
print(dim(cawi_de))
cat("\nSelected variables:\n")
print(names(cawi_de))
cat("\nGerman demographic weight summary:\n")
print(summary(cawi_de$wDemo_v1))
cat("\nsample1 distribution in raw data:\n")
print(table(cawi_raw$sample1, useNA = "ifany"))
cat("\nfilter_main_DE distribution in raw data (diagnostic only):\n")
print(table(cawi_raw$filter_main_DE, useNA = "ifany"))
cat("\nM63b_DE distribution in analysis sample:\n")
print(table(as_factor(cawi_de$M63b_DE), useNA = "ifany"))
