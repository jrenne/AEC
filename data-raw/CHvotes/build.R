# Run from the AEC root: Rscript --vanilla data-raw/CHvotes/build.R
# Rebuild the frozen snapshot without contacting any external service.
input <- "data-raw/CHvotes/swissvotes_dataset.csv"
expected <- "594dbafb5c9ae8f7563f1e0e3de00cac561993cdfd53034e86ed8bce1ddc3a35"
actual <- strsplit(system2("shasum", c("-a", "256", shQuote(input)), stdout = TRUE), " +")[[1]][1]
stopifnot(identical(actual, expected))
x <- read.csv(input,
  sep = ";", colClasses = "character", check.names = FALSE,
  na.strings = c("", "."), fileEncoding = "UTF-8-BOM"
)
date <- as.Date(x$datum, "%d.%m.%Y")
stopifnot(!anyNA(date))
# Keep all historical objects, including tie-break questions; exclude scheduled votes.
x <- x[date <= as.Date("2026-10-20"), , drop = FALSE]
date <- as.Date(x$datum, "%d.%m.%Y")
number <- function(z) {
  out <- suppressWarnings(as.numeric(z))
  stopifnot(!any(!is.na(z) & is.na(out)))
  out
}
forms <- c(
  "mandatory_referendum", "optional_referendum", "popular_initiative",
  "direct_counterproposal", "tie_break_question"
)
CHvotes <- data.frame(
  vote_id = x$anr, date = date, year = as.integer(format(date, "%Y")),
  title_fr = x$titel_kurz_f, title_en = x$titel_kurz_e, source_url = x$swissvoteslink,
  procedure = factor(x$rechtsform, levels = as.character(1:5), labels = forms),
  objects_on_day = as.integer(x$anzahl), eligible_voters = number(x$berecht),
  ballots_cast = number(x$stimmen), turnout_pct = number(x$bet),
  blank_ballots = number(x$leer), invalid_ballots = number(x$ungultig),
  valid_ballots = number(x$gultig), stringsAsFactors = FALSE
)
CHvotes <- CHvotes[order(CHvotes$date, as.numeric(CHvotes$vote_id)), ]
row.names(CHvotes) <- NULL
for (nm in names(CHvotes)) {
  if (is.character(CHvotes[[nm]])) {
    CHvotes[[nm]] <- enc2utf8(CHvotes[[nm]])
  }
}
cantons <- c(
  "ZH", "BE", "LU", "UR", "SZ", "OW", "NW", "GL", "ZG", "FR", "SO",
  "BS", "BL", "SH", "AR", "AI", "SG", "GR", "AG", "TG", "TI", "VD",
  "VS", "NE", "GE", "JU"
)
CHvotes_cantons <- do.call(rbind, lapply(cantons, function(ct) {
  p <- tolower(ct)
  data.frame(
    vote_id = x$anr, date = date, canton = ct,
    eligible_voters = number(x[[paste0(p, "-berecht")]]),
    ballots_cast = number(x[[paste0(p, "-stimmen")]]),
    turnout_pct = number(x[[paste0(p, "-bet")]]),
    valid_ballots = number(x[[paste0(p, "-gultig")]]), stringsAsFactors = FALSE
  )
}))
# Do not manufacture canton histories before observations exist (e.g. Jura).
CHvotes_cantons <- CHvotes_cantons[
  rowSums(!is.na(CHvotes_cantons[, 4:7])) > 0, ,
  drop = FALSE
]
CHvotes_cantons <- CHvotes_cantons[
  order(CHvotes_cantons$date, as.numeric(CHvotes_cantons$vote_id), CHvotes_cantons$canton),
]
row.names(CHvotes_cantons) <- NULL
stopifnot(
  !anyDuplicated(CHvotes$vote_id), !anyNA(CHvotes$procedure),
  !anyDuplicated(CHvotes_cantons[c("vote_id", "canton")])
)
save(CHvotes, file = "data/CHvotes.rda", compress = "xz", version = 2)
save(CHvotes_cantons, file = "data/CHvotes_cantons.rda", compress = "xz", version = 2)
