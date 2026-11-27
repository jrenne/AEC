source(if (file.exists("tests/helpers/compare-data.R")) "tests/helpers/compare-data.R" else "helpers/compare-data.R")
e <- new.env()
local <- file.exists("data/FRaccidents_daily.rda")
if (local) load("data/FRaccidents_daily.rda", envir = e) else utils::data("FRaccidents_daily", package = "AEC", envir = e)
d <- e$FRaccidents_daily
stopifnot(
  nrow(d) == 3287L, ncol(d) == 7L, !anyNA(d), !anyDuplicated(d$date),
  isTRUE(all.equal(d$date, seq(as.Date("2011-01-01"), as.Date("2019-12-31"), by = "day"))),
  sum(d$injury_accidents) == 57266L, any(d$injury_accidents == 0L),
  all(d$injury_accidents >= 0L), all(d$rain_mm >= 0),
  identical(head(d$injury_accidents), c(3L, 4L, 9L, 12L, 20L, 11L)),
  identical(head(d$rain_mm), c(0, 0, 0, 0, 14.7, 5.8))
)
root <- if (local) "inst" else system.file(package = "AEC")
m <- read.csv(file.path(root, "teaching-data/column-mappings.csv"))
stopifnot(setequal(names(d), m$variable[m$dataset == "FRaccidents_daily"]))
# Offline reproduction from installed compact inputs, rather than raw archives.
folder <- tempfile("aec-paris-rebuild-")
dir.create(folder)
dir.create(file.path(folder, "data-raw"))
dir.create(file.path(folder, "data"))
stopifnot(file.copy(file.path(root, "data-build/FRaccidents_daily"), file.path(folder, "data-raw"), recursive = TRUE))
old <- getwd()
setwd(folder)
tryCatch({
  rebuilt <- new.env()
  sys.source("data-raw/FRaccidents_daily/build.R", envir = rebuilt)
  assert_same_teaching_data(d, rebuilt$FRaccidents_daily)
}, finally = {
  setwd(old)
  unlink(folder, recursive = TRUE)
})
cat("PASS: Paris complete daily grid including zeros, conserved source counts, rainfall matching, mappings and installed offline rebuild.\n")
