# Supplementary code — Edwards (2026), *ÖkologischesWirtschaften* 3/2026

## Scope

R scripts reconstruct party-position indices from the Allianz Foundation Next Generations 2025 survey and CHES 2024 and estimate the article's weighted multinomial and linear models.

## Execution

Run the scripts in order from a fresh R session:

1. `01_CHES_preparation.R` — CHES party scores, correlations and plots.
2. `02_Allianz_CHES_linkage.R` — harmonised party propensities and respondent-level indices.
3. `03_Regression_models.R` — regressions, sample-flow workbook and session information.

Each script clears the R workspace, sets its own directory as the working directory, reads from `inputs/` (or the preceding script's restricted output), and writes to `outputs/`. Execute with `Rscript` or source a saved script in RStudio. Required packages are checked at runtime; scripts do not install packages.

Required inputs: 

- CHES 2024 data (available from https://www.chesdata.eu/ches-europe/): please save to `inputs/CHES_2024_final_v2.csv` 
- Allianz Next Generation 2025 survey microdata (available conditionally upon request from the Allianz Foundation): please save to `inputs/Allianz_2025.sav`. 

Script 02 writes `outputs/Allianz_2025_with_CHES.sav`; **do not publish this respondent-level file**. 

## Measures

- `galtan_index`: respondent voting propensities (Q30, 0–10) weighted by CHES party GAL–TAN positions; higher values indicate TAN orientation.
- `greenpos_index`: voting propensities weighted by CHES Green Position, calculated as the mean of `10 - climate_change` and `10 - environment`; higher values indicate greener party positions.
- `greensal_index`: voting propensities weighted by mean CHES `climate_change_salience` and `environment_salience`.
- Party propensities coded 11 are set to missing. The original SPSS implementation uses ordinary arithmetic in numerators (missing values propagate) and `SUM()` in denominators (missing values ignored). The R translation preserves these rules; a zero or missing denominator yields a missing index.
- Party coverage: Germany 7, Spain 8, France 7, Italy 6, Poland 4. Volt (DE), Azione and Italia Viva (IT), and Trzecia Droga (PL) are excluded from the indices, as in the original SPSS code.

Party scores are hardcoded in script 02 to preserve the original SPSS values. This decision expedited work across country-specific software versions and avoided encoding problems in party-name matching. Future development should replace hardcoding with a party lookup table and explicit encoding instructions.

These indices measure affinity for expert-coded **party positions**, not direct respondent attitudes.

## Regression specification

- Sample: `filter_young == 1` (ages 16–39); five study countries; `gew > 0`; complete cases.
- Exclusions: respondents classified as `Other gender`; education category 4 (`Still at school`); missing model fields. The sample-flow workbook reports exclusions by stage.
- Predictors: `fac1_pd_hi` (political deprivation), `fac2_ra_hi` (retrograde aspirations), `fac3_rv_hi` (regressive values), `fac4_et_hi` (extraordinary tactics). `ext_tac_3` is not used.
- Controls: age `q01`, gender `qsex_natrep`, education `qeducation` (numeric ordinal), and country (factor; Germany reference). Education is assumed linear per category increment.
- Multinomial outcome: `typ_galtan` (GAL / Centre / TAN), Centre reference. Estimates are exponentiated multinomial coefficients (relative risk ratios).
- OLS outcome: `greenpos_index`.
- `gew` was supplied by the fieldwork partner. Weight construction, calibration targets and normalisation details have been requested. This README will be updated when documentation is received. Model-based standard errors do not incorporate full survey-design variance estimation.

## Errata: GAL–TAN categories

The published description uses integer ranges (GAL 0–3; Centre 4–6; TAN 7–10). The model applies `cut(galtan_index, breaks=c(-Inf,3,6,Inf), right=TRUE)` to a continuous index: **GAL ≤3; Centre >3 to ≤6; TAN >6**. The analysis and its cutpoints are unchanged.

## Output inventory

| Script | Output(s) |
|---|---|
| 01 | `ches_allianz_green_prepared.csv`, `ches_green_correlations_full_vs_allianz.csv`, `ches_allianz_green_correlations_by_country.csv`, `ches_allianz_green_vs_galtan.png`, `ches_allianz_green_vs_lrgen.png` |
| 02 | `Allianz_2025_with_CHES.sav` (restricted), `Index_validation.csv` (for validation against prior SPSS results - not distributed here) | 
| 03 | `AFNG_galtan_multinom_pd_weighted_young.xlsx`, `AFNG_greenpos_lm_weighted_young.xlsx`, `Sample_flow.xlsx`, `sessionInfo.txt` |

The scripts require restricted survey microdata to reproduce respondent-level results. 

## Credits

Research: Allianz Foundation and SINUS-Institute -- please see https://next-generations-study.com/ 
Analysis: James Rhys Edwards (coding support and process standardisation: OpenAI ChatGPT). Responsibility for analysis decisions and verification remains with the author.
