# Reproduce weighted regressions and sample flow.
rm(list = ls(all.names = TRUE))
gc(verbose = FALSE)
script_file <- function() {
  args <- commandArgs(trailingOnly = FALSE)
  flag <- grep("^--file=", args, value = TRUE)
  if (length(flag)) return(normalizePath(sub("^--file=", "", flag[1]), mustWork = TRUE))
  frames <- sys.frames()
  for (i in rev(seq_along(frames))) {
    f <- frames[[i]]$ofile
    if (!is.null(f) && file.exists(f)) return(normalizePath(f, mustWork = TRUE))
  }
  if (requireNamespace("rstudioapi", quietly = TRUE) && rstudioapi::isAvailable()) {
    f <- rstudioapi::getSourceEditorContext()$path
    if (nzchar(f) && file.exists(f)) return(normalizePath(f, mustWork = TRUE))
  }
  stop("Cannot locate script. Run with Rscript or source() from a saved file.")
}
root <- dirname(script_file())
setwd(root)
input_dir <- file.path(root, "inputs")
output_dir <- file.path(root, "outputs")
dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
for (pkg in c("haven", "dplyr", "tidyr", "nnet", "broom", "writexl")) {
  if (!requireNamespace(pkg, quietly = TRUE)) stop("Install required package: ", pkg)
}

infile <- file.path(output_dir, "Allianz_2025_with_CHES.sav")
if (!file.exists(infile)) stop("Run 02_Allianz_CHES_linkage.R first: ", infile)
df <- haven::read_sav(infile)
# Use numeric country codes to avoid retaining disqualified/over-quota levels.
code <- as.numeric(haven::zap_labels(df$qcountry))
df$qcountry <- factor(code, levels=1:5,
  labels=c("Germany", "Spain", "France", "Italy", "Poland"))
df$qsex_natrep <- haven::as_factor(df$qsex_natrep)
df$qeducation <- as.numeric(haven::zap_labels(df$qeducation))
df$qeducation[df$qeducation == 0] <- NA_real_

flow <- data.frame(step=character(), n_remaining=integer(), n_excluded=integer())
record <- function(label, before, after) {
  data.frame(step=label, n_remaining=after, n_excluded=before-after)
}
flow <- rbind(flow, data.frame(step="Input survey",n_remaining=nrow(df),n_excluded=NA_integer_))
filter_step <- function(d, keep, label) {
  # Missing filter conditions are excluded.
  before <- nrow(d)
  d <- d[!is.na(keep) & keep, , drop=FALSE]
  flow <<- rbind(flow, record(label,before,nrow(d)))
  d
}
df <- filter_step(df, df$filter_young == 1, "Age 16-39 (filter_young=1)")
df <- filter_step(df, !is.na(df$qcountry), "Valid country (DE ES FR IT PL)")
df <- filter_step(df, !is.na(df$gew) & df$gew > 0, "Positive nonmissing gew")
df <- filter_step(df, !is.na(df$qsex_natrep) & as.character(df$qsex_natrep) != "Other gender", "Exclude other gender")
df <- filter_step(df, !is.na(df$qeducation) & df$qeducation != 4, "Exclude still at school / education missing")
df <- droplevels(df)

for (nm in c("fac1_pd_hi", "fac2_ra_hi", "fac3_rv_hi", "fac4_et_hi")) {
  raw <- as.numeric(haven::zap_labels(df[[nm]]))
  df[[nm]] <- factor(raw, levels=c(0,1), labels=if(nm == "fac4_et_hi") c("No","Yes") else c("Low","High"))
}
df$typ_galtan <- cut(as.numeric(df$galtan_index),
  breaks=c(-Inf,3,6,Inf), labels=c("GAL","Centre","TAN"),right=TRUE)

vars <- c("typ_galtan", "greenpos_index", "fac1_pd_hi", "fac2_ra_hi",
          "fac3_rv_hi", "fac4_et_hi", "qcountry", "q01", "qsex_natrep", "qeducation", "gew")
# Common complete-case set, enabling direct comparison between outcomes.
model_df <- df[stats::complete.cases(df[,vars,drop=FALSE]),vars,drop=FALSE]
flow <- rbind(flow,record("Complete cases: both regression outcomes and covariates",nrow(df),nrow(model_df)))
model_df <- droplevels(model_df)
model_df$typ_galtan <- stats::relevel(model_df$typ_galtan, ref="Centre")
model_df$qcountry <- stats::relevel(model_df$qcountry, ref="Germany")

formula_mnl <- typ_galtan ~ fac1_pd_hi + fac2_ra_hi + fac3_rv_hi + fac4_et_hi +
  qcountry + q01 + qsex_natrep + qeducation
formula_lm <- greenpos_index ~ fac1_pd_hi + fac2_ra_hi + fac3_rv_hi + fac4_et_hi +
  qcountry + q01 + qsex_natrep + qeducation
mod_mnl <- nnet::multinom(formula_mnl,data=model_df,weights=gew,maxit=1000,trace=FALSE)
mod_lm <- stats::lm(formula_lm,data=model_df,weights=gew)

mnl_coefs <- broom::tidy(mod_mnl,exponentiate=TRUE,conf.int=TRUE)
mnl_fit <- data.frame(AIC=stats::AIC(mod_mnl),logLik=as.numeric(stats::logLik(mod_mnl)),nobs=nrow(model_df))
lm_coefs <- broom::tidy(mod_lm,conf.int=TRUE)
lm_fit <- broom::glance(mod_lm)

writexl::write_xlsx(list(Coefficients=mnl_coefs,Model_Fit=mnl_fit),file.path(output_dir,"AFNG_galtan_multinom_pd_weighted_young.xlsx"))
writexl::write_xlsx(list(Coefficients=lm_coefs,Model_Fit=lm_fit),file.path(output_dir,"AFNG_greenpos_lm_weighted_young.xlsx"))
writexl::write_xlsx(list(Sample_Flow=flow,
  Analytic_N=data.frame(outcome=c("GAL-TAN multinomial","Green Position OLS"),n=nrow(model_df)),
  GAL_TAN_Frequencies=as.data.frame(table(model_df$typ_galtan))),file.path(output_dir,"Sample_flow.xlsx"))
writeLines(capture.output(sessionInfo()),file.path(output_dir,"sessionInfo.txt"))
cat("Analytic N:",nrow(model_df),"\n")
