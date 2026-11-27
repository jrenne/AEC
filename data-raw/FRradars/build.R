# Offline reconstruction from the compact integer-count extraction.
folder <- "data-raw/FRradars"
m <- read.dcf(file.path(folder, "checksums.dcf"))
for (i in seq_len(nrow(m))) {
  input <- file.path(folder, m[i, "File"])
  checksum <- system2("shasum", c("-a", "256", shQuote(input)), stdout = TRUE)
  actual <- strsplit(checksum, " +")[[1]][1]
  stopifnot(identical(actual, unname(m[i, "SHA256"])))
}
FRradars <- read.csv(file.path(folder, "stack-counts.csv.gz"), stringsAsFactors = FALSE)
FRradars$anchor_month <- as.Date(FRradars$anchor_month)
FRradars$installation_month <- as.Date(FRradars$installation_month)
stopifnot(
  nrow(FRradars) == 21939L, ncol(FRradars) == 10L,
  sum(FRradars$treated) == 406L, length(unique(FRradars$site_id)) == 639L,
  !anyDuplicated(FRradars[c("stack_id", "site_id")])
)
save(FRradars, file = "data/FRradars.rda", version = 2, compress = "xz")
