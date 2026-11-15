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
# Source: CHES_2024_final_v2.csv. Outputs are party-level, not respondent-level.
for (pkg in c("dplyr", "readr", "tidyr", "purrr", "ggplot2", "ggrepel")) {
  if (!requireNamespace(pkg, quietly = TRUE)) stop("Install required package: ", pkg)
}
ches <- readr::read_csv(file.path(input_dir, "CHES_2024_final_v2.csv"), show_col_types = FALSE)
ches <- dplyr::mutate(ches,
  green_climate = 10 - climate_change,
  green_environment = 10 - environment,
  green_position = rowMeans(cbind(green_climate, green_environment), na.rm = TRUE),
  green_salience = rowMeans(cbind(climate_change_salience, environment_salience), na.rm = TRUE)
)
ches$green_position[is.nan(ches$green_position)] <- NA_real_
ches$green_salience[is.nan(ches$green_salience)] <- NA_real_
country_codes <- c(Germany = 3, Spain = 5, France = 6, Italy = 8, Poland = 26)
subset <- dplyr::filter(ches, country %in% unname(country_codes))
subset$country_name <- names(country_codes)[match(subset$country, country_codes)]
readr::write_csv(subset, file.path(output_dir, "ches_allianz_green_prepared.csv"))
cor_pairs <- data.frame(
 x=c("green_climate", "climate_change_salience", "green_position", "green_position", "green_salience", "green_salience", "galtan"),
 y=c("green_environment", "environment_salience", "galtan", "lrgen", "galtan", "lrgen", "lrgen"), stringsAsFactors=FALSE)
calc <- function(data, sample) {
  purrr::map_dfr(seq_len(nrow(cor_pairs)), function(i) {
    x <- cor_pairs$x[i]; y <- cor_pairs$y[i]
    z <- data[, c(x,y)]; z <- z[stats::complete.cases(z), ,drop=FALSE]
    t <- if(nrow(z) >= 3 && stats::sd(z[[x]]) > 0 && stats::sd(z[[y]]) > 0) stats::cor.test(z[[x]],z[[y]]) else NULL
    data.frame(sample=sample, x=x, y=y, n=nrow(z), pearson_r=if(is.null(t)) NA_real_ else unname(t$estimate), p_value=if(is.null(t)) NA_real_ else t$p.value)
  })
}
readr::write_csv(dplyr::bind_rows(calc(ches,"Full CHES"),calc(subset,"Allianz countries")),file.path(output_dir,"ches_green_correlations_full_vs_allianz.csv"))
readr::write_csv(purrr::map_dfr(unique(subset$country_name), function(c) calc(subset[subset$country_name==c,],c)),file.path(output_dir,"ches_allianz_green_correlations_by_country.csv"))
for (v in c("galtan","lrgen")) {
  p <- ggplot2::ggplot(subset, ggplot2::aes(x=.data[[v]],y=green_position,label=party,color=country_name)) +
    ggplot2::geom_point() + ggplot2::geom_smooth(method="lm",se=FALSE) +
    ggrepel::geom_text_repel(size=3,max.overlaps=30) + ggplot2::theme_minimal() +
    ggplot2::labs(x=v,y="Green Position",color="Country")
  ggplot2::ggsave(file.path(output_dir,paste0("ches_allianz_green_vs_",v,".png")),p,width=9,height=6,dpi=300)
}
