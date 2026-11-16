# 04_M57_agreement_DE_AfD_vs_other.R
# Germany: weighted agreement on selected M57 items, comparing respondents who
# attribute cultural-policy competence to the AfD with respondents selecting
# any other listed party in M63b_DE.
#
# Main Excel sheet: Column A = item, B = AfD, C = all other parties.
# QA sheet: unweighted counts for every valid response category (1-5), by group.

library(dplyr)
library(haven)
library(survey)
library(openxlsx)
library(tidyr)

if (!exists("cawi_de")) source("01_wrangling_OpenMusE_DE.R")

m57_vars <- c(
  "M57_2", "M57_3", "M57_4", "M57_5", "M57_6", "M57_7",
  "M57_9", "M57_10", "M57_11", "M57_12", "M57_13", "M57_14"
)
required_vars <- c(m57_vars, "M63b_DE", "wDemo_v1")
missing_vars <- setdiff(required_vars, names(cawi_de))
if (length(missing_vars) > 0) stop("Missing required variables: ", paste(missing_vars, collapse = ", "))

item_lookup <- tibble(
  item = m57_vars,
  item_label = vapply(m57_vars, function(v) {
    lab <- attr(cawi_de[[v]], "label")
    if (is.null(lab)) v else lab
  }, character(1))
)

# M63b_DE codes: 1 CDU/CSU, 2 SPD, 3 FDP, 4 Greens, 5 Left, 6 AfD, 7 BSW.
# Missing/other values are excluded from this comparison.
cawi_m57 <- cawi_de %>%
  mutate(
    party_code = as.numeric(M63b_DE),
    group = case_when(
      party_code == 6 ~ "AfD",
      party_code %in% c(1, 2, 3, 4, 5, 7) ~ "All other parties",
      TRUE ~ NA_character_
    ),
    group = factor(group, levels = c("AfD", "All other parties"))
  ) %>%
  filter(!is.na(group))

for (v in m57_vars) {
  x <- as.numeric(cawi_m57[[v]])
  cawi_m57[[paste0(v, "_agree")]] <- case_when(
    x %in% c(4, 5) ~ 1,
    x %in% c(1, 2, 3) ~ 0,
    TRUE ~ NA_real_
  )
}

des_m57 <- svydesign(ids = ~1, weights = ~wDemo_v1, data = cawi_m57)

weighted_pct <- function(design, var_name) {
  est <- svymean(as.formula(paste0("~", var_name)), design = design, na.rm = TRUE)
  100 * as.numeric(coef(est))[1]
}

# Main table: weighted % agreeing (responses 4-5).
main_long <- bind_rows(lapply(m57_vars, function(v) {
  bind_rows(lapply(levels(cawi_m57$group), function(g) {
    rows <- cawi_m57$group == g
    tibble(item = v, group = g,
           agree_percentage = weighted_pct(des_m57[rows, ], paste0(v, "_agree")))
  }))
}))

m57_AfD_vs_other <- main_long %>%
  left_join(item_lookup, by = "item") %>%
  select(item, item_label, group, agree_percentage) %>%
  mutate(agree_percentage = round(agree_percentage, 2)) %>%
  pivot_wider(names_from = group, values_from = agree_percentage) %>%
  select(item, item_label, AfD, `All other parties`)

# QA: unweighted counts in each original 1-5 response category, by item/group.
qa_counts <- bind_rows(lapply(m57_vars, function(v) {
  tibble(
    item = v,
    group = cawi_m57$group,
    response = as.numeric(cawi_m57[[v]])
  ) %>%
    filter(response %in% 1:5) %>%
    count(item, group, response, name = "unweighted_count") %>%
    complete(item, group = levels(cawi_m57$group), response = 1:5,
             fill = list(unweighted_count = 0))
})) %>%
  left_join(item_lookup, by = "item") %>%
  select(item, item_label, group, response, unweighted_count) %>%
  arrange(match(item, m57_vars), group, response)

# Additional group-size QA for M63b_DE before item-level missingness.
group_counts <- cawi_m57 %>%
  count(group, name = "unweighted_group_n")

wb <- createWorkbook()
addWorksheet(wb, "Agreement")
writeData(wb, "Agreement", m57_AfD_vs_other)
addWorksheet(wb, "QA_response_counts")
writeData(wb, "QA_response_counts", qa_counts)
addWorksheet(wb, "QA_group_counts")
writeData(wb, "QA_group_counts", group_counts)

header_style <- createStyle(textDecoration = "bold", fgFill = "#D9EAF7", border = "Bottom")
for (s in names(wb)) {
  addStyle(wb, s, header_style, rows = 1, cols = 1:ncol(readWorkbook(wb, sheet = s)), gridExpand = TRUE)
  freezePane(wb, s, firstRow = TRUE)
  setColWidths(wb, s, cols = 1:ncol(readWorkbook(wb, sheet = s)), widths = "auto")
}

saveWorkbook(wb, "outputs/M57_agreement_DE_AfD_vs_other.xlsx", overwrite = TRUE)

cat("\nM57 weighted % agreement (4-5): AfD vs all other parties\n")
print(m57_AfD_vs_other, n = Inf, width = Inf)
cat("\nQA group counts\n")
print(group_counts)
cat("\nExported: M57_agreement_DE_AfD_vs_other.xlsx\n")
