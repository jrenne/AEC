# Run from the AEC root; all compact inputs are included for offline rebuilding.
root <- "data-raw/FRaccidents_daily"
meta <- read.dcf(file.path(root, "checksums.dcf"))
for (n in c("accidents-daily.csv.gz", "weather-daily.csv.gz")) {
  field <- if (n == "accidents-daily.csv.gz") "Accidents-SHA256" else "Weather-SHA256"
  input <- file.path(root, n)
  checksum <- system2("shasum", c("-a", "256", shQuote(input)), stdout = TRUE)
  actual <- strsplit(checksum, " +")[[1]][1]
  stopifnot(identical(actual, unname(meta[1, field])))
}
a <- read.csv(gzfile(file.path(root, "accidents-daily.csv.gz")))
w <- read.csv(gzfile(file.path(root, "weather-daily.csv.gz")))
stopifnot(!anyDuplicated(a$date), !anyDuplicated(w$date), identical(a$date, w$date))
FRaccidents_daily <- merge(a, w, by = "date", sort = TRUE)
FRaccidents_daily$date <- as.Date(FRaccidents_daily$date)
FRaccidents_daily$injury_accidents <- as.integer(FRaccidents_daily$injury_accidents)
FRaccidents_daily$rain_quality <- as.integer(FRaccidents_daily$rain_quality)
FRaccidents_daily$weekday <- as.integer(format(FRaccidents_daily$date, "%u"))
FRaccidents_daily$month <- as.integer(format(FRaccidents_daily$date, "%m"))
FRaccidents_daily$year <- as.integer(format(FRaccidents_daily$date, "%Y"))
stopifnot(
  nrow(FRaccidents_daily) == 3287L, all(diff(FRaccidents_daily$date) == 1),
  !anyNA(FRaccidents_daily), all(FRaccidents_daily$rain_mm >= 0),
  all(FRaccidents_daily$injury_accidents >= 0),
  sum(FRaccidents_daily$injury_accidents) == as.integer(meta[1, "Accidents-retained"])
)
save(FRaccidents_daily, file = "data/FRaccidents_daily.rda", compress = "xz", version = 2)
print(c(
  days = nrow(FRaccidents_daily), accidents = sum(FRaccidents_daily$injury_accidents),
  size_bytes = file.info("data/FRaccidents_daily.rda")$size
))
