# OpenMusE German cultural-policy survey analysis

**Documentation updated:** 16 November 2026  
**Scope:** German OpenMusE CAWI survey, Block B. This README documents the *supplied R scripts* and their intended outputs.

## 1. Project setup and data

Keep `OpenMusE_DE.Rproj`, this README, and all seven numbered `.R` scripts in the same RStudio project directory. Open the `.Rproj` file in RStudio; scripts use paths relative to the project root and do not require `setwd()`.

The wrangling script expects the SPSS file named:

`OpenMusE_T3.2_CAP_CAWI_clean_analysis_postcode_enriched.sav`

For access to this file contact the OpenMusE project director: jamesrhys.edwards@sinus-institut.de Place the `.sav` file in the `inputs/` sub-directory or change `data_path` in that script to its actual location.

Install required packages once:

```r
install.packages(c("haven", "dplyr", "stringr", "survey", "openxlsx", "tidyr"))
```

The scripts load packages individually; `tidyr` is used by the wide-table and AfD-versus-other-party scripts, and `stringr` is loaded by wrangling.

## 2. Population, grouping and weights

- **Analysis sample:** German Block B general population, defined by `sample1 == 2` in `01_wrangling_OpenMusE_DE.R`.
- **Diagnostic only:** `filter_main_DE` is retained and tabulated but does *not* define the sample.
- **Weight:** within-country demographic weight `wDemo_v1` is applied in `survey::svydesign(ids = ~1, weights = ~wDemo_v1, data = ...)`.
- **Party grouping:** `M63b_DE` is the respondent's forced-choice answer about which party would be best at setting cultural policy. Note that this is not necessarily the respondent's vote choice or party identification.
- **Counts:** reported `count` values are unweighted; percentages, standard errors and confidence intervals are survey-weighted, except marked QA counts.
- **Uncertainty:** scripts use a simple survey design (`ids = ~1`) with demographic weights.

The wrangling script selects `S0`, `S2_REC`, `S3`, `S4`, the `M57`, `M61`, `M62`, and `M63` variable families, `M59`, `M63b_DE`, `wDemo_v1`, `filter_main_DE`, and `sample1`. It preserves SPSS value labels in `cawi_de_labelled` and creates `cawi_de` for subsequent scripts.

## 3. Script inventory and outputs

| Script | Analysis | Output location |
|---|---|---|
| `01_wrangling_OpenMusE_DE.R` | Imports `.sav`, filters German Block B, selects variables and prints diagnostics. | R objects `cawi_de`, `cawi_de_labelled`; console diagnostics; no file export. |
| `02_M63b_DE_distribution.R` | Weighted distribution of party considered best at setting cultural policy (`M63b_DE`). | `outputs/M63b_DE_distribution.xlsx` |
| `03_M61_agreement_DE_by_party.R` | Weighted agreement on `M61_1`–`M61_11`, overall and by `M63b_DE` party. | `outputs/M61_agreement_DE_by_party.xlsx` |
| `03_M61_agreement_DE_AfD_vs_other.R` | Weighted M61 agreement among AfD selectors versus selectors of other listed parties, plus QA counts. | **Project root:** `M61_agreement_DE_AfD_vs_other.xlsx` |
| `04_M57_agreement_DE_by_party.R` | Weighted agreement on 12 selected M57 items, overall and by `M63b_DE` party. | `outputs/M57_agreement_DE_by_party.xlsx` |
| `04_M57_agreement_DE_AfD_vs_other.R` | Weighted M57 agreement among AfD selectors versus selectors of other listed parties, plus QA counts. | **Project root:** `M57_agreement_DE_AfD_vs_other.xlsx` |
| `05_M62_M63_support_DE_by_party.R` | Weighted three-category distributions for six M62 and eleven selected M63 items, overall and by `M63b_DE` party. | `outputs/M62_M63_support_DE_by_party.xlsx` |

### 3.1 `M63b_DE`: perceived party competence

`02_M63b_DE_distribution.R` uses the SPSS value labels as party names and exports `party`, unweighted `count`, weighted `column_percentage`, weighted `se`, and approximate 95% `ci_low`/`ci_high` (estimate ± 1.96 × SE). The script creates `outputs/` for use in the publication.

### 3.2 `M61`: agreement statements

`03_M61_agreement_DE_by_party.R` covers `M61_1` through `M61_11`. The script recodes responses **4 or 5 as agreement**, **1–3 as non-agreement**, and all other values as missing. Its workbook contains `DE_overall`, `By_party`, and `By_party_wide`, including weighted agreement percentages and (in the long tables) unweighted valid counts, SEs and 95% intervals.

`03_M61_agreement_DE_AfD_vs_other.R` uses the same agreement rule but compares `M63b_DE == 6` (AfD) with codes `1, 2, 3, 4, 5, 7` (other listed parties). Missing and other codes are excluded. Its workbook contains `Agreement`, `QA_response_counts` (unweighted counts by original response category 1–5) and `QA_group_counts` (unweighted group sizes before item-level missingness). The main comparison is descriptive; it does not implement a significance test.

### 3.3 `M57`: agreement statements

`04_M57_agreement_DE_by_party.R` and `04_M57_agreement_DE_AfD_vs_other.R` use these 12 items:

`M57_2`, `M57_3`, `M57_4`, `M57_5`, `M57_6`, `M57_7`, `M57_9`, `M57_10`, `M57_11`, `M57_12`, `M57_13`, `M57_14`.

As for M61, responses **4–5 = agree**, **1–3 = do not agree**, and others are missing. The by-party workbook contains `DE_overall`, `By_party`, `By_party_wide`. The AfD-versus-other workbook contains `Agreement`, `QA_response_counts`, and `QA_group_counts`, with the same M63b_DE party-code comparison as above.

### 3.4 `M62` and `M63`: support/oppose distributions

`05_M62_M63_support_DE_by_party.R` analyzes `M62_1`–`M62_6` and the following M63 items:

`M63_2`, `M63_3`, `M63_4`, `M63_6`, `M63_7`, `M63_8`, `M63_10`, `M63_11`, `M63_12`, `M63_15`, `M63_16`.

Here the response scale is **1 = oppose**, **2 = neither oppose nor support**, **3 = support**. Unlike the agreement scripts, this script retains all three categories. The exported workbook contains `DE_overall`, `By_party`, and `By_party_wide`, with weighted category percentages, standard errors, confidence intervals, and unweighted category counts in the long tables.

## 4. Running the workflow

In a fresh RStudio session, verify the data file is accessible, then run:

```r
source("01_wrangling_OpenMusE_DE.R")
source("02_M63b_DE_distribution.R")
source("03_M61_agreement_DE_by_party.R")
source("03_M61_agreement_DE_AfD_vs_other.R")
source("04_M57_agreement_DE_by_party.R")
source("04_M57_agreement_DE_AfD_vs_other.R")
source("05_M62_M63_support_DE_by_party.R")
```

Most analysis scripts automatically source the wrangling script when `cawi_de` is absent. However, explicitly running Step 1 first makes the sample definition and diagnostics visible.

**Before running out of sequence:** create `outputs/` in the project directory (or add `dir.create("outputs", showWarnings = FALSE)` to each script that writes there). Only `02_M63b_DE_distribution.R` currently creates this directory itself; scripts `03_*_by_party.R`, `04_*_by_party.R`, and `05_*` assume it already exists.

## 5. Interpretation and reproducibility cautions

1. **Party attribution is not partisan identification.** Comparisons by `M63b_DE` describe respondents' perceived cultural-policy competence, not necessarily supporters or voters of those parties. Avoid calling these groups “AfD voters” or “party supporters” without an independent measure.
2. **Scale recoding:** M57 and M61 treat the neutral midpoint (3) as *non-agreement*, not missing. This is an analytical choice that should be retained in any replication and sensitivity analysis.
3. **Nonresponse and sparse groups:** Missing or invalid item responses are excluded item by item. Review the QA counts and weighted effective sample sizes before interpreting small-party contrasts.
4. **Intervals and multiple comparisons:** The reported 95% intervals are descriptive uncertainty estimates under the specified survey design; the scripts do not correct for multiple testing or fit adjusted models.
5. **Question wording:** The scripts retrieve SPSS variable labels. The questionnaire / codebook are needed to interpret the substantive meaning and polarity of each item, and to verify the `M63b_DE` code mapping.
6. **Outputs are generated, not source data:** Keep raw `.sav` and scripts versioned/managed separately from derived `.xlsx` tables. Consider logging R version, package versions, data checksum, and run date.
