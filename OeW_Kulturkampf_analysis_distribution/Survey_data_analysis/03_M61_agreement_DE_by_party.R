# 03_M61_agreement_DE_by_party.R
# Weighted agreement (responses 4-5) on M61_1 to M61_11,
# overall for German Block B and by M63b_DE party attribution.

library(dplyr)
library(haven)
library(survey)
library(openxlsx)

# Run wrangling if the analysis object is not already in memory.
if (!exists("cawi_de")) {
  source("01_wrangling_OpenMusE_DE.R")
}

m61_vars <- paste0("M61_", 1:11)

# Check that all required variables are present.
required_vars <- c(m61_vars, "M63b_DE", "wDemo_v1")
missing_vars <- setdiff(required_vars, names(cawi_de))
if (length(missing_vars) > 0) {
  stop("Missing required variables: ", paste(missing_vars, collapse = ", "))
}

# Preserve question wording from SPSS variable labels where available.
item_lookup <- tibble(
  item = m61_vars,
  item_label = vapply(
    m61_vars,
    function(v) {
      lab <- attr(cawi_de[[v]], "label")
      if (is.null(lab)) v else lab
    },
    character(1)
  )
)

# Create analysis copy with numeric 1-5 M61 responses, binary agreement,
# and labelled party factor. Agreement = 1 for 4/5, 0 for 1/2/3.
cawi_m61 <- cawi_de %>%
  mutate(
    party = haven::as_factor(M63b_DE, levels = "labels")
  )

for (v in m61_vars) {
  x <- as.numeric(cawi_m61[[v]])
  cawi_m61[[paste0(v, "_agree")]] <- case_when(
    x %in% c(4, 5) ~ 1,
    x %in% c(1, 2, 3) ~ 0,
    TRUE ~ NA_real_
  )
}

# Survey design using German demographic weight.
des_m61 <- svydesign(
  ids = ~1,
  weights = ~wDemo_v1,
  data = cawi_m61
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
overall_list <- lapply(m61_vars, function(v) {
  agree_var <- paste0(v, "_agree")
  stats <- weighted_agreement(des_m61, agree_var)

  tibble(
    item = v,
    count = sum(!is.na(cawi_m61[[agree_var]]))
  ) %>%
    bind_cols(stats)
})

m61_de_overall <- bind_rows(overall_list) %>%
  left_join(item_lookup, by = "item") %>%
  select(item, item_label, count, agree_percentage, se, ci_low, ci_high) %>%
  mutate(across(c(agree_percentage, se, ci_low, ci_high), ~round(.x, 2)))

# -----------------------------------------------------------------------------
# B. By party considered best at setting cultural policy (M63b_DE)
# -----------------------------------------------------------------------------
party_levels <- levels(cawi_m61$party)

by_party_list <- list()
row_id <- 1

for (v in m61_vars) {
  agree_var <- paste0(v, "_agree")

  for (p in party_levels) {
    rows <- !is.na(cawi_m61$party) & cawi_m61$party == p
    des_party <- des_m61[rows, ]

    stats <- weighted_agreement(des_party, agree_var)

    by_party_list[[row_id]] <- tibble(
      item = v,
      party = p,
      count = sum(rows & !is.na(cawi_m61[[agree_var]]))
    ) %>%
      bind_cols(stats)

    row_id <- row_id + 1
  }
}

m61_by_party <- bind_rows(by_party_list) %>%
  left_join(item_lookup, by = "item") %>%
  select(item, item_label, party, count, agree_percentage, se, ci_low, ci_high) %>%
  mutate(across(c(agree_percentage, se, ci_low, ci_high), ~round(.x, 2)))

# Convenience wide table: weighted % agreeing only.
m61_by_party_wide <- m61_by_party %>%
  select(item, item_label, party, agree_percentage) %>%
  tidyr::pivot_wider(
    names_from = party,
    values_from = agree_percentage
  )

# -----------------------------------------------------------------------------
# Console output
# -----------------------------------------------------------------------------
cat("\nM61 agreement: Germany overall\n")
cat("Agreement = responses 4 (somewhat agree) or 5 (strongly agree).\n")
cat("Count is unweighted; percentages/SE/CIs use wDemo_v1.\n\n")
print(m61_de_overall, n = Inf)

cat("\nM61 agreement by party considered best at setting cultural policy (M63b_DE)\n")
cat("Agreement = responses 4 (somewhat agree) or 5 (strongly agree).\n")
cat("Count is unweighted within party; percentages/SE/CIs use wDemo_v1.\n\n")
print(m61_by_party, n = Inf)

cat("\nM61 weighted agreement percentages by party (wide view)\n\n")
print(m61_by_party_wide, n = Inf, width = Inf)

# -----------------------------------------------------------------------------
# Excel export to RStudio Project root
# -----------------------------------------------------------------------------
write.xlsx(
  list(
    DE_overall = m61_de_overall,
    By_party = m61_by_party,
    By_party_wide = m61_by_party_wide
  ),
  file = "outputs/M61_agreement_DE_by_party.xlsx",
  overwrite = TRUE
)

cat("\nExported: M61_agreement_DE_by_party.xlsx\n")
