# 05_M62_M63_support_DE_by_party.R
# Weighted three-category distributions for selected M62 and M63 items,
# overall for German Block B and by M63b_DE party attribution.
# Response scale: 1 = oppose, 2 = neither oppose nor support, 3 = support.

library(dplyr)
library(haven)
library(survey)
library(openxlsx)
library(tidyr)

# Run wrangling if the analysis object is not already in memory.
if (!exists("cawi_de")) {
  source("01_wrangling_OpenMusE_DE.R")
}

m62_vars <- paste0("M62_", 1:6)

m63_vars <- c(
  "M63_2", "M63_3", "M63_4", "M63_6", "M63_7", "M63_8",
  "M63_10", "M63_11", "M63_12", "M63_15", "M63_16"
)

analysis_vars <- c(m62_vars, m63_vars)

# Check that all required variables are present.
required_vars <- c(analysis_vars, "M63b_DE", "wDemo_v1")
missing_vars <- setdiff(required_vars, names(cawi_de))
if (length(missing_vars) > 0) {
  stop("Missing required variables: ", paste(missing_vars, collapse = ", "))
}

# Preserve question wording from SPSS variable labels where available.
item_lookup <- tibble(
  item = analysis_vars,
  item_label = vapply(
    analysis_vars,
    function(v) {
      lab <- attr(cawi_de[[v]], "label")
      if (is.null(lab)) v else lab
    },
    character(1)
  )
)

response_lookup <- tibble(
  response_code = 1:3,
  response = c("Oppose", "Neither oppose nor support", "Support")
)

# Create analysis copy with numeric response variables and labelled party factor.
cawi_support <- cawi_de %>%
  mutate(
    party = haven::as_factor(M63b_DE, levels = "labels")
  )

for (v in analysis_vars) {
  cawi_support[[v]] <- as.numeric(cawi_support[[v]])
}

# Survey design using German demographic weight.
des_support <- svydesign(
  ids = ~1,
  weights = ~wDemo_v1,
  data = cawi_support
)

# Helper: weighted share, SE, and 95% CI for one response category.
weighted_category <- function(design, var_name, response_code) {
  indicator_name <- ".response_indicator"
  design$variables[[indicator_name]] <- as.numeric(
    design$variables[[var_name]] == response_code
  )
  design$variables[[indicator_name]][is.na(design$variables[[var_name]])] <- NA_real_

  est <- svymean(
    as.formula(paste0("~", indicator_name)),
    design = design,
    na.rm = TRUE
  )
  ci <- confint(est)

  tibble(
    column_percentage = 100 * as.numeric(coef(est))[1],
    se = 100 * as.numeric(SE(est))[1],
    ci_low = 100 * ci[1, 1],
    ci_high = 100 * ci[1, 2]
  )
}

# -----------------------------------------------------------------------------
# A. Germany overall
# -----------------------------------------------------------------------------
overall_list <- list()
row_id <- 1

for (v in analysis_vars) {
  for (code in 1:3) {
    stats <- weighted_category(des_support, v, code)

    overall_list[[row_id]] <- tibble(
      item = v,
      response_code = code,
      count = sum(!is.na(cawi_support[[v]]) & cawi_support[[v]] == code)
    ) %>%
      bind_cols(stats)

    row_id <- row_id + 1
  }
}

support_de_overall <- bind_rows(overall_list) %>%
  left_join(item_lookup, by = "item") %>%
  left_join(response_lookup, by = "response_code") %>%
  select(
    item, item_label, response_code, response, count,
    column_percentage, se, ci_low, ci_high
  ) %>%
  mutate(
    across(c(column_percentage, se, ci_low, ci_high), ~round(.x, 2))
  )

# -----------------------------------------------------------------------------
# B. By party considered best at setting cultural policy (M63b_DE)
# -----------------------------------------------------------------------------
party_levels <- levels(cawi_support$party)
by_party_list <- list()
row_id <- 1

for (v in analysis_vars) {
  for (p in party_levels) {
    rows <- !is.na(cawi_support$party) & cawi_support$party == p
    des_party <- des_support[rows, ]

    for (code in 1:3) {
      stats <- weighted_category(des_party, v, code)

      by_party_list[[row_id]] <- tibble(
        item = v,
        party = p,
        response_code = code,
        count = sum(
          rows & !is.na(cawi_support[[v]]) & cawi_support[[v]] == code
        )
      ) %>%
        bind_cols(stats)

      row_id <- row_id + 1
    }
  }
}

support_by_party <- bind_rows(by_party_list) %>%
  left_join(item_lookup, by = "item") %>%
  left_join(response_lookup, by = "response_code") %>%
  select(
    item, item_label, party, response_code, response, count,
    column_percentage, se, ci_low, ci_high
  ) %>%
  mutate(
    across(c(column_percentage, se, ci_low, ci_high), ~round(.x, 2))
  )

# Convenience wide table: weighted response percentages by party.
support_by_party_wide <- support_by_party %>%
  select(item, item_label, response_code, response, party, column_percentage) %>%
  pivot_wider(
    names_from = party,
    values_from = column_percentage
  )

# -----------------------------------------------------------------------------
# Console output
# -----------------------------------------------------------------------------
cat("\nSelected M62/M63 response distributions: Germany overall\n")
cat("Scale: 1 = oppose, 2 = neither oppose nor support, 3 = support.\n")
cat("Count is unweighted; percentages/SE/CIs use wDemo_v1.\n\n")
print(support_de_overall, n = Inf, width = Inf)

cat("\nSelected M62/M63 response distributions by party considered best at setting cultural policy (M63b_DE)\n")
cat("Scale: 1 = oppose, 2 = neither oppose nor support, 3 = support.\n")
cat("Count is unweighted within party; percentages/SE/CIs use wDemo_v1.\n\n")
print(support_by_party, n = Inf, width = Inf)

cat("\nSelected M62/M63 weighted response percentages by party (wide view)\n\n")
print(support_by_party_wide, n = Inf, width = Inf)

# -----------------------------------------------------------------------------
# Excel export to RStudio Project root
# -----------------------------------------------------------------------------
write.xlsx(
  list(
    DE_overall = support_de_overall,
    By_party = support_by_party,
    By_party_wide = support_by_party_wide
  ),
  file = "outputs/M62_M63_support_DE_by_party.xlsx",
  overwrite = TRUE
)

cat("\nExported: M62_M63_support_DE_by_party.xlsx\n")
