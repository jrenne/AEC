# Run from the AEC root: Rscript --vanilla data-raw/CHaccidents/build.R
# Source: City of Zurich, CC BY; required credit: Bundesamt fuer Strassen ASTRA.
input <- "data-raw/CHaccidents/RoadTrafficAccidentLocations.csv"
expected <- "df426e859fecd37cd7365f273662459688b1862482957960402696e8722d766f"
actual <- strsplit(system2("shasum", c("-a", "256", shQuote(input)), stdout = TRUE), " +")[[1]][1]
stopifnot(identical(actual, expected))
x <- read.csv(input,
  colClasses = "character", check.names = FALSE,
  na.strings = c("", "NA"), fileEncoding = "UTF-8-BOM"
)
number <- function(z) {
  out <- suppressWarnings(as.numeric(z))
  stopifnot(!any(!is.na(z) & is.na(out)))
  out
}
boolean <- function(z) {
  stopifnot(all(is.na(z) | z %in% c("true", "false")))
  ifelse(is.na(z), NA, z == "true")
}
CHaccidents <- data.frame(
  accident_id = x$AccidentUID, year = as.integer(x$AccidentYear),
  month = as.integer(x$AccidentMonth),
  weekday = as.integer(sub("aw40", "", x$AccidentWeekDay)),
  hour = as.integer(x$AccidentHour),
  accident_type_code = x$AccidentType, accident_type = x$AccidentType_en,
  accident_type_fr = x$AccidentType_fr,
  severity_code = x$AccidentSeverityCategory, severity = x$AccidentSeverityCategory_en,
  severity_fr = x$AccidentSeverityCategory_fr,
  involves_pedestrian = boolean(x$AccidentInvolvingPedestrian),
  involves_bicycle = boolean(x$AccidentInvolvingBicycle),
  involves_motorcycle = boolean(x$AccidentInvolvingMotorcycle),
  road_type_code = x$RoadType, road_type = x$RoadType_en, road_type_fr = x$RoadType_fr,
  easting_lv95 = number(x$AccidentLocation_CHLV95_E),
  northing_lv95 = number(x$AccidentLocation_CHLV95_N), canton = x$CantonCode,
  municipality_code = x$MunicipalityCode,
  injury = x$AccidentSeverityCategory %in% c("as1", "as2", "as3"),
  severe = x$AccidentSeverityCategory %in% c("as1", "as2"),
  fatal = x$AccidentSeverityCategory == "as1", stringsAsFactors = FALSE
)
stopifnot(all(CHaccidents$severity_code %in% paste0("as", 1:4)))
CHaccidents <- CHaccidents[order(
  CHaccidents$year, CHaccidents$month,
  CHaccidents$accident_id
), ]
row.names(CHaccidents) <- NULL
# Mark international labels explicitly so installed data are portable across locales.
for (nm in names(CHaccidents)) {
  if (is.character(CHaccidents[[nm]])) {
    CHaccidents[[nm]] <- enc2utf8(CHaccidents[[nm]])
  }
}
stopifnot(
  !anyDuplicated(CHaccidents$accident_id),
  all(CHaccidents$canton == "ZH"),
  all(CHaccidents$municipality_code == "0261"),
  all(CHaccidents$month %in% 1:12),
  all(CHaccidents$weekday %in% 1:7), all(CHaccidents$hour %in% 0:23)
)
CHaccidents_monthly <- aggregate(
  cbind(
    accidents = rep(1L, nrow(CHaccidents)),
    injury_accidents = as.integer(CHaccidents$injury),
    severe_accidents = as.integer(CHaccidents$severe),
    fatal_accidents = as.integer(CHaccidents$fatal)
  ),
  by = CHaccidents[c("year", "month")], FUN = sum
)
CHaccidents_monthly$date <- as.Date(sprintf(
  "%04d-%02d-01",
  CHaccidents_monthly$year, CHaccidents_monthly$month
))
CHaccidents_monthly <- CHaccidents_monthly[
  order(CHaccidents_monthly$date),
  c("date", "year", "month", "accidents", "injury_accidents", "severe_accidents", "fatal_accidents")
]
row.names(CHaccidents_monthly) <- NULL
save(CHaccidents, file = "data/CHaccidents.rda", compress = "xz", version = 2)
save(CHaccidents_monthly, file = "data/CHaccidents_monthly.rda", compress = "xz", version = 2)
