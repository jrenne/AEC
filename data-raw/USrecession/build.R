# Run from a writable AEC/rebuild root; base R and shasum suffice offline.
folder <- "data-raw/USrecession"
manifest <- read.dcf(file.path(folder, "checksums.dcf"))
for (i in seq_len(nrow(manifest))) {
  path <- file.path(folder, manifest[i, "File"])
  actual <- strsplit(system2("shasum", c("-a", "256", shQuote(path)), stdout = TRUE), " +")[[1]][1]
  stopifnot(identical(actual, unname(manifest[i, "SHA256"])))
}
rates <- read.csv(file.path(folder, "h15-monthly.csv"), stringsAsFactors = FALSE)
cycles <- read.csv(file.path(folder, "nber-cycles.csv"), stringsAsFactors = FALSE)
dates <- as.Date(paste0(substr(rates$source_period, 1, 7), "-01"))
stopifnot(
  identical(dates, seq(as.Date("1982-01-01"), as.Date("2024-12-01"), by = "month")),
  !anyNA(rates), all(is.finite(rates$yield_3m)), all(is.finite(rates$yield_10y))
)
recession <- integer(length(dates))
for (i in seq_len(nrow(cycles))) {
  recession[dates > as.Date(cycles$peak[i]) & dates <= as.Date(cycles$trough[i])] <- 1L
}
target_dates <- as.Date(paste0(as.integer(format(dates, "%Y")) + 1L, "-", format(dates, "%m"), "-01"))
USrecession <- data.frame(
  date = dates,
  yield_3m = rates$yield_3m, yield_10y = rates$yield_10y,
  term_spread = rates$yield_10y - rates$yield_3m,
  recession = recession,
  target_date_12m = target_dates,
  recession_12m = recession[match(target_dates, dates)]
)
stopifnot(
  nrow(USrecession) == 516L, ncol(USrecession) == 7L,
  sum(USrecession$recession) == 47L,
  sum(USrecession$recession_12m, na.rm = TRUE) == 36L,
  sum(is.na(USrecession$recession_12m)) == 12L
)
save(USrecession, file = "data/USrecession.rda", version = 2, compress = "xz")
mapping <- data.frame(
  dataset = "USrecession", variable = names(USrecession),
  source_or_transformation = c(
    "H.15 source_period: month-end changed to first-of-month label",
    "H15/RIFLGFCM03_N.M: monthly business-day average; percent per annum",
    "H15/RIFLGFCY10_N.M: monthly business-day average; percent per annum",
    "yield_10y minus yield_3m; percentage points",
    "NBER chronology: date greater than peak month and at most trough month",
    "date plus 12 calendar months",
    "recession at matched target_date_12m; NA if beyond dataset coverage"
  )
)
write.csv(mapping, file.path(folder, "column-mappings.csv"), row.names = FALSE)
