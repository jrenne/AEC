# Offline rebuild from AEC root (or a writable root containing data-raw and data).
folder <- "data-raw/CHapples"
manifest <- read.dcf(file.path(folder, "checksums.dcf"))
for (i in seq_len(nrow(manifest))) {
  input <- file.path(folder, manifest[i, "File"])
  checksum <- system2("shasum", c("-a", "256", shQuote(input)), stdout = TRUE)
  actual <- strsplit(checksum, " +")[[1]][1]
  stopifnot(identical(actual, unname(manifest[i, "SHA256"])))
}
w <- read.csv(file.path(folder, "weather-daily.csv.gz"), stringsAsFactors = FALSE)
w$date <- as.Date(w$date)
w$year <- as.integer(format(w$date, "%Y"))
stopifnot(
  nrow(w) == 2440L, !anyNA(w), !anyDuplicated(w[c("station", "date")]),
  all(format(w$date, "%m") %in% c("04", "05"))
)
groups <- split(w, interaction(w$station, w$year, drop = TRUE))
CHapples_frost <- do.call(rbind, lapply(groups, function(x) {
  stopifnot(nrow(x) == 61L, all(sort(x$date) == seq(as.Date(paste0(x$year[1], "-04-01")), as.Date(paste0(x$year[1], "-05-31")), by = "day")))
  data.frame(
    station = x$station[1], station_name = if (x$station[1] == "SIO") "Sion" else "Guettingen",
    canton = if (x$station[1] == "SIO") "VS" else "TG", year = x$year[1],
    frost_days = sum(x$tmin_c < 0), valid_days = sum(!is.na(x$tmin_c)), expected_days = 61L,
    minimum_tmin_c = min(x$tmin_c), cold_degree_days = sum(pmax(0, -x$tmin_c))
  )
}))
CHapples_frost <- CHapples_frost[order(CHapples_frost$year, CHapples_frost$station), ]
row.names(CHapples_frost) <- NULL
CHapples <- read.csv(file.path(folder, "market.csv"), stringsAsFactors = FALSE, na.strings = "")
CHapples$date <- as.Date(CHapples$date)
for (station in c("SIO", "GUT")) {
  x <- CHapples_frost[CHapples_frost$station == station, ]
  CHapples[[paste0("frost_", tolower(station), "_days")]] <- x$frost_days[match(CHapples$harvest_year, x$year)]
}
CHapples$frost_mean_days <- (CHapples$frost_sio_days + CHapples$frost_gut_days) / 2
stopifnot(
  nrow(CHapples) == 44L, ncol(CHapples) == 10L, nrow(CHapples_frost) == 40L,
  !anyDuplicated(CHapples[c("date", "variety")]), sum(is.na(CHapples$price_chf_kg)) == 1L,
  all(CHapples$quantity_t > 0), all(CHapples$price_chf_kg > 0, na.rm = TRUE),
  all(CHapples$harvest_year == as.integer(format(CHapples$date, "%Y")) - (as.integer(format(CHapples$date, "%m")) < 9L))
)
# Published September--June totals and quantity-weighted prices, not sample means.
for (v in c("Gala", "Golden Delicious")) {
  for (y in 2022:2023) {
    x <- subset(CHapples, variety == v & harvest_year == y & !format(date, "%m") %in% c("07", "08"))
    total <- if (v == "Gala") c(18267, 18115) else c(5772, 5492)
    price <- if (v == "Gala") c(2.1601107607394234, 2.2399586925605313) else c(1.9375466039374907, 2.052273442716506)
    stopifnot(
      nrow(x) == 10L, sum(x$quantity_t) == total[y - 2021L],
      abs(weighted.mean(x$price_chf_kg, x$quantity_t) - price[y - 2021L]) < 1e-12
    )
  }
}
for (obj in c("CHapples", "CHapples_frost")) save(list = obj, file = paste0("data/", obj, ".rda"), version = 2, compress = "xz")
