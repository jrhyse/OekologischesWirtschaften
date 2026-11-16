# 02_M63b_DE_distribution.R
# Weighted distribution of M63b_DE: party considered best at setting cultural policy

library(dplyr)
library(haven)
library(survey)
library(openxlsx)

# Run wrangling if the analysis object is not already in memory.
if (!exists("cawi_de")) {
  source("01_wrangling_OpenMusE_DE.R")
}

# Survey design using German demographic weight.
des_de <- svydesign(
  ids = ~1,
  weights = ~wDemo_v1,
  data = cawi_de
)

# Value-label lookup from the SPSS variable.
party_labels <- attr(cawi_de$M63b_DE, "labels")
party_lookup <- tibble(
  M63b_DE = as.numeric(party_labels),
  party = names(party_labels)
)

# Unweighted counts.
counts <- cawi_de %>%
  transmute(M63b_DE = as.numeric(M63b_DE)) %>%
  filter(!is.na(M63b_DE)) %>%
  count(M63b_DE, name = "count")

# Weighted column proportions and uncertainty.
weighted <- svymean(~factor(M63b_DE), design = des_de, na.rm = TRUE)
weighted_df <- tibble(
  M63b_DE = as.numeric(sub("factor\\(M63b_DE\\)", "", names(coef(weighted)))),
  column_percentage = 100 * as.numeric(coef(weighted)),
  se = 100 * as.numeric(SE(weighted))
) %>%
  mutate(
    ci_low = column_percentage - 1.96 * se,
    ci_high = column_percentage + 1.96 * se
  )

m63b_distribution <- party_lookup %>%
  left_join(counts, by = "M63b_DE") %>%
  left_join(weighted_df, by = "M63b_DE") %>%
  select(party, count, column_percentage, se, ci_low, ci_high) %>%
  mutate(across(c(column_percentage, se, ci_low, ci_high), ~round(.x, 2)))

cat("\nM63b_DE: party considered best at setting cultural policy\n")
cat("Count is unweighted; percentages/SE/CIs use wDemo_v1.\n\n")
print(m63b_distribution, n = Inf)

# Export.
dir.create("outputs", showWarnings = FALSE)
write.xlsx(
  m63b_distribution,
  file = "outputs/M63b_DE_distribution.xlsx",
  sheetName = "M63b_DE",
  overwrite = TRUE
)

cat("\nExported: outputs/M63b_DE_distribution.xlsx\n")
