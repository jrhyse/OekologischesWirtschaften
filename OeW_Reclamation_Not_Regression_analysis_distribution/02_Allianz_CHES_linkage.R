# Run from Rscript or source() in RStudio. No hardcoded machine path.
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
# Reproduces original SPSS propensity-weighted indices using fixed party scores.
# Scores and party coverage transcribed from 13079_AF_voting_galtan.txt
# and 13079_AF_voting_green_modernisation.sps. Do not remap by party name.
for (pkg in c("haven", "dplyr", "readr")) if (!requireNamespace(pkg, quietly=TRUE)) stop("Install required package: ",pkg)
infile <- file.path(input_dir, "Allianz 25 Gesamt Datensatz 0815_analysis_postcode_enriched.sav")
if (!file.exists(infile)) stop("Missing input: ", infile)
df <- haven::read_sav(infile)
# Use numeric SPSS values; preserve 11 as missing in derived party propensities.
country <- as.numeric(haven::zap_labels(df$qcountry))
df$CDU <- as.numeric(haven::zap_labels(df$q30de_r1))
df$CDU[!is.na(df$CDU) & df$CDU == 11] <- NA_real_
df$SPD <- as.numeric(haven::zap_labels(df$q30de_r2))
df$SPD[!is.na(df$SPD) & df$SPD == 11] <- NA_real_
df$FDP <- as.numeric(haven::zap_labels(df$q30de_r3))
df$FDP[!is.na(df$FDP) & df$FDP == 11] <- NA_real_
df$Grunen <- as.numeric(haven::zap_labels(df$q30de_r4))
df$Grunen[!is.na(df$Grunen) & df$Grunen == 11] <- NA_real_
df$DL <- as.numeric(haven::zap_labels(df$q30de_r5))
df$DL[!is.na(df$DL) & df$DL == 11] <- NA_real_
df$AfD <- as.numeric(haven::zap_labels(df$q30de_r6))
df$AfD[!is.na(df$AfD) & df$AfD == 11] <- NA_real_
df$BSW <- as.numeric(haven::zap_labels(df$q30de_r7))
df$BSW[!is.na(df$BSW) & df$BSW == 11] <- NA_real_
df$Volt <- as.numeric(haven::zap_labels(df$q30de_r8))
df$Volt[!is.na(df$Volt) & df$Volt == 11] <- NA_real_
df$PSOE <- as.numeric(haven::zap_labels(df$q30es_r1))
df$PSOE[!is.na(df$PSOE) & df$PSOE == 11] <- NA_real_
df$PP <- as.numeric(haven::zap_labels(df$q30es_r2))
df$PP[!is.na(df$PP) & df$PP == 11] <- NA_real_
df$Vox <- as.numeric(haven::zap_labels(df$q30es_r3))
df$Vox[!is.na(df$Vox) & df$Vox == 11] <- NA_real_
df$Sumar <- as.numeric(haven::zap_labels(df$q30es_r4))
df$Sumar[!is.na(df$Sumar) & df$Sumar == 11] <- NA_real_
df$ERC <- as.numeric(haven::zap_labels(df$q30es_r5))
df$ERC[!is.na(df$ERC) & df$ERC == 11] <- NA_real_
df$Junts <- as.numeric(haven::zap_labels(df$q30es_r6))
df$Junts[!is.na(df$Junts) & df$Junts == 11] <- NA_real_
df$EAJPNV <- as.numeric(haven::zap_labels(df$q30es_r7))
df$EAJPNV[!is.na(df$EAJPNV) & df$EAJPNV == 11] <- NA_real_
df$Podemos <- as.numeric(haven::zap_labels(df$q30es_r8))
df$Podemos[!is.na(df$Podemos) & df$Podemos == 11] <- NA_real_
df$RN <- as.numeric(haven::zap_labels(df$q30fr_r1))
df$RN[!is.na(df$RN) & df$RN == 11] <- NA_real_
df$RE <- as.numeric(haven::zap_labels(df$q30fr_r2))
df$RE[!is.na(df$RE) & df$RE == 11] <- NA_real_
df$FI_FR <- as.numeric(haven::zap_labels(df$q30fr_r3))
df$FI_FR[!is.na(df$FI_FR) & df$FI_FR == 11] <- NA_real_
df$LR <- as.numeric(haven::zap_labels(df$q30fr_r4))
df$LR[!is.na(df$LR) & df$LR == 11] <- NA_real_
df$LEEELV <- as.numeric(haven::zap_labels(df$q30fr_r5))
df$LEEELV[!is.na(df$LEEELV) & df$LEEELV == 11] <- NA_real_
df$PS <- as.numeric(haven::zap_labels(df$q30fr_r6))
df$PS[!is.na(df$PS) & df$PS == 11] <- NA_real_
df$REC <- as.numeric(haven::zap_labels(df$q30fr_r7))
df$REC[!is.na(df$REC) & df$REC == 11] <- NA_real_
df$FDI <- as.numeric(haven::zap_labels(df$q30it_r1))
df$FDI[!is.na(df$FDI) & df$FDI == 11] <- NA_real_
df$PD <- as.numeric(haven::zap_labels(df$q30it_r2))
df$PD[!is.na(df$PD) & df$PD == 11] <- NA_real_
df$MS5 <- as.numeric(haven::zap_labels(df$q30it_r3))
df$MS5[!is.na(df$MS5) & df$MS5 == 11] <- NA_real_
df$FI_IT <- as.numeric(haven::zap_labels(df$q30it_r4))
df$FI_IT[!is.na(df$FI_IT) & df$FI_IT == 11] <- NA_real_
df$Lega <- as.numeric(haven::zap_labels(df$q30it_r5))
df$Lega[!is.na(df$Lega) & df$Lega == 11] <- NA_real_
df$SI <- as.numeric(haven::zap_labels(df$q30it_r6))
df$SI[!is.na(df$SI) & df$SI == 11] <- NA_real_
df$Azione <- as.numeric(haven::zap_labels(df$q30it_r7))
df$Azione[!is.na(df$Azione) & df$Azione == 11] <- NA_real_
df$IV <- as.numeric(haven::zap_labels(df$q30it_r8))
df$IV[!is.na(df$IV) & df$IV == 11] <- NA_real_
df$KO <- as.numeric(haven::zap_labels(df$q30pl_r1))
df$KO[!is.na(df$KO) & df$KO == 11] <- NA_real_
df$NL <- as.numeric(haven::zap_labels(df$q30pl_r2))
df$NL[!is.na(df$NL) & df$NL == 11] <- NA_real_
df$TD <- as.numeric(haven::zap_labels(df$q30pl_r3))
df$TD[!is.na(df$TD) & df$TD == 11] <- NA_real_
df$PiS <- as.numeric(haven::zap_labels(df$q30pl_r4))
df$PiS[!is.na(df$PiS) & df$PiS == 11] <- NA_real_
df$Konf <- as.numeric(haven::zap_labels(df$q30pl_r5))
df$Konf[!is.na(df$Konf) & df$Konf == 11] <- NA_real_
# SPSS SUM() ignores missing propensity values in the denominator.
# Ordinary arithmetic in the numerator propagates any missing propensity.
# Preserve both behaviours. Zero denominator yields missing index.
sp_sum <- function(d, parties) {
  m <- as.matrix(d[, parties, drop=FALSE])
  n <- rowSums(m, na.rm=TRUE)
  n[rowSums(!is.na(m)) == 0L] <- NA_real_
  n
}
sp_weighted <- function(d, parties, scores) {
  m <- as.matrix(d[, parties, drop=FALSE])
  numerator <- as.vector(m %*% scores)  # NA propagates, including for NA*0
  denominator <- sp_sum(d, parties)
  ifelse(!is.na(denominator) & denominator > 0, numerator / denominator, NA_real_)
}
df$galtan_index <- NA_real_
df$greenpos_index <- NA_real_
df$greensal_index <- NA_real_
## Germany
idx <- which(!is.na(country) & country == 1)
if (length(idx)) {
  parties <- c("CDU", "SPD", "FDP", "Grunen", "DL", "AfD", "BSW")
  df$galtan_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(7.05, 3.61, 3.22, 1.61, 2.29, 9.39, 7.06))
  df$greenpos_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(4.37778, 6.63333, 3.48333, 9.27222, 6.83333, 0.77778, 2.57639))
  df$greensal_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(5.20556, 5.50000, 5.50000, 8.80556, 5.31250, 5.16667, 4.84028))
}
## Spain
idx <- which(!is.na(country) & country == 2)
if (length(idx)) {
  parties <- c("PSOE", "PP", "Vox", "Sumar", "ERC", "Junts", "EAJPNV", "Podemos")
  df$galtan_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(2.94, 7.00, 9.50, 1.20, 2.57, 5.93, 6.20, 1.44))
  df$greenpos_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(7.15179, 3.95536, 0.85714, 8.39286, 7.01429, 4.95714, 5.03571, 7.81250))
  df$greensal_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(5.64286, 3.64286, 5.64286, 7.00000, 5.16667, 4.21667, 4.58333, 6.35714))
}
## France
idx <- which(!is.na(country) & country == 3)
if (length(idx)) {
  parties <- c("RN", "RE", "FI_FR", "LR", "LEEELV", "PS", "REC")
  df$galtan_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(8.36, 4.09, 1.82, 7.18, 1.70, 2.73, 9.10))
  df$greenpos_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(2.25000, 4.91667, 7.20833, 3.33333, 8.62500, 6.70833, 1.91667))
  df$greensal_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(4.22500, 4.77500, 7.07500, 3.07500, 9.62500, 6.75000, 2.93333))
}
## Italy
idx <- which(!is.na(country) & country == 4)
if (length(idx)) {
  parties <- c("FDI", "PD", "MS5", "FI_IT", "Lega", "SI")
  df$galtan_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(9.13, 2.33, 3.27, 6.07, 8.87, 1.69))
  df$greenpos_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(3.50000, 7.49107, 8.03571, 3.42857, 2.30357, 8.40000))
  df$greensal_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(3.61607, 6.91964, 6.67857, 3.07143, 4.16964, 7.72500))
}
## Poland
idx <- which(!is.na(country) & country == 5)
if (length(idx)) {
  parties <- c("KO", "NL", "PiS", "Konf")
  df$galtan_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(3.66, 1.75, 8.45, 8.41))
  df$greenpos_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(6.39286, 7.91758, 2.14286, 0.99451))
  df$greensal_index[idx] <- sp_weighted(df[idx, , drop=FALSE], parties, c(5.20879, 7.30769, 4.86264, 5.95833))
}
# Export a derived SAV for the next stage; raw survey fields remain restricted.
# The output contains respondent-level data and must not be published.
haven::write_sav(df, file.path(output_dir, "Allianz_2025_with_CHES.sav"))
checks <- data.frame(variable=c("galtan_index","greenpos_index","greensal_index"),
 n_valid=vapply(df[c("galtan_index","greenpos_index","greensal_index")],function(x)sum(!is.na(x)),numeric(1)),
 n_missing=vapply(df[c("galtan_index","greenpos_index","greensal_index")],function(x)sum(is.na(x)),numeric(1)),
 mean=vapply(df[c("galtan_index","greenpos_index","greensal_index")],function(x)mean(x,na.rm=TRUE),numeric(1)),
 sd=vapply(df[c("galtan_index","greenpos_index","greensal_index")],function(x)stats::sd(x,na.rm=TRUE),numeric(1)))
readr::write_csv(checks,file.path(output_dir,"Index_validation.csv"))
