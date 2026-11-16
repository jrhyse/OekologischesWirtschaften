# 04_M57_agreement_DE_by_party.R
# Weighted agreement (responses 4-5) on selected M57 items,
# overall for German Block B and by M63b_DE party attribution.

library(dplyr)
library(haven)
library(survey)
library(openxlsx)
library(tidyr)

# Run wrangling if the analysis object is not already in memory.
if (!exists("cawi_de")) {
  source("01_wrangling_OpenMusE_DE.R")
}

m57_vars <- c(
  "M57_2", "M57_3", "M57_4", "M57_5", "M57_6", "M57_7",
  "M57_9", "M57_10", "M57_11", "M57_12", "M57_13", "M57_14"
)

# Check that all required variables are present.
required_vars <- c(m57_vars, "M63b_DE", "wDemo_v1")
missing_vars <- setdiff(required_vars, names(cawi_de))
if (length(missing_vars) > 0) {
  stop("Missing required variables: ", paste(missing_vars, collapse = ", "))
}

# Preserve question wording from SPSS variable labels where available.
item_lookup <- tibble(
  item = m57_vars,
  item_label = vapply(
    m57_vars,
    function(v) {
      lab <- attr(cawi_de[[v]], "label")
      if (is.null(lab)) v else lab
    },
    character(1)
  )
)

# Create analysis copy with binary agreement and labelled party factor.
# Agreement = 1 for 4/5, 0 for 1/2/3.
cawi_m57 <- cawi_de %>%
  mutate(
    party = haven::as_factor(M63b_DE, levels = "labels")
  )

for (v in m57_vars) {
  x <- as.numeric(cawi_m57[[v]])
  cawi_m57[[paste0(v, "_agree")]] <- case_when(
    x %in% c(4, 5) ~ 1,
    x %in% c(1, 2, 3) ~ 0,
    TRUE ~ NA_real_
  )
}

# Survey design using German demographic weight.
des_m57 <- svydesign(
  ids = ~1,
  weights = ~wDemo_v1,
  data = cawi_m57
)

# Helper: extract weighted proportion, SE, and 95% CI for one binary variable.
weighted_agreement <- function(design, var_name) {
  est <- svymean(
    as.formula(paste0("~", var_name)),
    design = design,
    na.rm = TRUE
  )
  ci <- confint(est)

  tibble(
    agree_percentage = 100 * as.numeric(coef(est))[1],
    se = 100 * as.numeric(SE(est))[1],
    ci_low = 100 * ci[1, 1],
    ci_high = 100 * ci[1, 2]
  )
}

# -----------------------------------------------------------------------------
# A. Germany overall
# -----------------------------------------------------------------------------
overall_list <- lapply(m57_vars, function(v) {
  agree_var <- paste0(v, "_agree")
  stats <- weighted_agreement(des_m57, agree_var)

  tibble(
    item = v,
    count = sum(!is.na(cawi_m57[[agree_var]]))
  ) %>%
    bind_cols(stats)
})

m57_de_overall <- bind_rows(overall_list) %>%
  left_join(item_lookup, by = "item") %>%
  select(item, item_label, count, agree_percentage, se, ci_low, ci_high) %>%
  mutate(across(c(agree_percentage, se, ci_low, ci_high), ~round(.x, 2)))

# -----------------------------------------------------------------------------
# B. By party considered best at setting cultural policy (M63b_DE)
# -----------------------------------------------------------------------------
party_levels <- levels(cawi_m57$party)

by_party_list <- list()
row_id <- 1

for (v in m57_vars) {
  agree_var <- paste0(v, "_agree")

  for (p in party_levels) {
    rows <- !is.na(cawi_m57$party) & cawi_m57$party == p
    des_party <- des_m57[rows, ]

    stats <- weighted_agreement(des_party, agree_var)

    by_party_list[[row_id]] <- tibble(
      item = v,
      party = p,
      count = sum(rows & !is.na(cawi_m57[[agree_var]]))
    ) %>%
      bind_cols(stats)

    row_id <- row_id + 1
  }
}

m57_by_party <- bind_rows(by_party_list) %>%
  left_join(item_lookup, by = "item") %>%
  select(item, item_label, party, count, agree_percentage, se, ci_low, ci_high) %>%
  mutate(across(c(agree_percentage, se, ci_low, ci_high), ~round(.x, 2)))

# Convenience wide table: weighted % agreeing only.
m57_by_party_wide <- m57_by_party %>%
  select(item, item_label, party, agree_percentage) %>%
  pivot_wider(
    names_from = party,
    values_from = agree_percentage
  )

# -----------------------------------------------------------------------------
# Console output
# -----------------------------------------------------------------------------
cat("\nSelected M57 agreement: Germany overall\n")
cat("Agreement = responses 4 (somewhat agree) or 5 (strongly agree).\n")
cat("Count is unweighted; percentages/SE/CIs use wDemo_v1.\n\n")
print(m57_de_overall, n = Inf)

cat("\nSelected M57 agreement by party considered best at setting cultural policy (M63b_DE)\n")
cat("Agreement = responses 4 (somewhat agree) or 5 (strongly agree).\n")
cat("Count is unweighted within party; percentages/SE/CIs use wDemo_v1.\n\n")
print(m57_by_party, n = Inf)

cat("\nSelected M57 weighted agreement percentages by party (wide view)\n\n")
print(m57_by_party_wide, n = Inf, width = Inf)

# -----------------------------------------------------------------------------
# Excel export to RStudio Project root
# -----------------------------------------------------------------------------
write.xlsx(
  list(
    DE_overall = m57_de_overall,
    By_party = m57_by_party,
    By_party_wide = m57_by_party_wide
  ),
  file = "outputs/M57_agreement_DE_by_party.xlsx",
  overwrite = TRUE
)

cat("\nExported: M57_agreement_DE_by_party.xlsx\n")
