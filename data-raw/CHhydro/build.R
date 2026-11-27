# Offline base-R rebuild from a writable root containing data-raw/CHhydro and data/.
folder <- "data-raw/CHhydro"
manifest <- read.dcf(file.path(folder, "checksums.dcf"))
for (i in seq_len(nrow(manifest))) {
  input <- file.path(folder, manifest[i, "File"])
  checksum <- system2("shasum", c("-a", "256", shQuote(input)), stdout = TRUE)
  actual <- strsplit(checksum, " +")[[1]][1]
  stopifnot(identical(actual, unname(manifest[i, "SHA256"])))
}
CHhydro <- read.csv(file.path(folder, "electricity-daily.csv.gz"), stringsAsFactors = FALSE)
CHhydro$date <- as.Date(CHhydro$date)
w <- read.csv(file.path(folder, "weather-daily.csv.gz"), stringsAsFactors = FALSE)
w$date <- as.Date(w$date)
stopifnot(nrow(w) == 6590L, !anyNA(w), !anyDuplicated(w[c("station", "date")]))
CHhydro$wind_de_mw <- CHhydro$wind_onshore_de_mw + CHhydro$wind_offshore_de_mw
for (station in c("SIO", "GUT")) {
  x <- w[w$station == station, ]
  stopifnot(all(x$date == seq(as.Date("2015-12-25"), as.Date("2024-12-31"), by = "day")))
  index <- match(CHhydro$date, x$date)
  CHhydro[[paste0("temperature_", tolower(station), "_c")]] <- x$temperature_c[index]
  CHhydro[[paste0("rain_", tolower(station), "_mm")]] <- x$rain_mm[index]
  CHhydro[[paste0("rain_previous7_", tolower(station), "_mm")]] <- vapply(index, function(i) sum(x$rain_mm[(i - 7L):(i - 1L)]), numeric(1))
}
stopifnot(
  nrow(CHhydro) == 3288L, ncol(CHhydro) == 18L,
  all(CHhydro$date == seq(as.Date("2016-01-01"), as.Date("2024-12-31"), by = "day")),
  sum(CHhydro$hours) == 78912L, all(CHhydro$hours %in% 23:25),
  sum(CHhydro$hours == 23L) == 9L, sum(CHhydro$hours == 25L) == 9L,
  sum(is.na(CHhydro$river_mw)) == 10L,
  all(is.na(CHhydro$river_mw) == (CHhydro$river_valid_hours < CHhydro$hours)),
  sum(CHhydro$price_eur_mwh < 0) == 6L,
  !anyNA(CHhydro[names(CHhydro) != "river_mw"]), all(CHhydro$reservoir_mw > 0)
)
save(CHhydro, file = "data/CHhydro.rda", version = 2, compress = "xz")
