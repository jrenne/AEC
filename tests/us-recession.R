e <- new.env()
if (file.exists("data/USrecession.rda")) {
  load("data/USrecession.rda", envir = e)
} else {
  utils::data("USrecession", package = "AEC", envir = e)
}
d <- e$USrecession
stopifnot(
  nrow(d) == 516L, ncol(d) == 7L,
  identical(d$date, seq(as.Date("1982-01-01"), as.Date("2024-12-01"), by = "month")),
  !anyDuplicated(d$date), !anyNA(d[, 1:6]),
  all(d$recession %in% 0:1), sum(d$recession) == 47,
  identical(d$term_spread, d$yield_10y - d$yield_3m),
  identical(d$recession_12m, c(d$recession[13:516], rep(NA_integer_, 12)))
)
# Independent checks of the peak-excluded/trough-included dating convention.
status <- function(date) d$recession[match(as.Date(date), d$date)]
stopifnot(identical(
  status(c(
    "1990-07-01", "1990-08-01", "1991-03-01", "1991-04-01",
    "2007-12-01", "2008-01-01", "2009-06-01", "2009-07-01",
    "2020-02-01", "2020-03-01", "2020-04-01", "2020-05-01"
  )),
  c(0L, 1L, 1L, 0L, 0L, 1L, 1L, 0L, 0L, 1L, 1L, 0L)
))
z <- d[!is.na(d$recession_12m), ]
h <- z$term_spread < 0
y <- z$recession_12m == 1
stopifnot(
  nrow(z) == 504, sum(y) == 36, sum(!y) == 468,
  sum(h & y) == 13, sum(h & !y) == 28, sum(!h & y) == 23, sum(!h & !y) == 440
)
# Equality belongs to the no-warning side of W > a; lower thresholds warn more.
rates <- vapply(c(-1, -.5, 0, .5), function(a) {
  w <- -z$term_spread > a
  c(mean(w[!y]), mean(w[y]))
}, numeric(2))
stopifnot(all(diff(rates[1, ]) <= 0), all(diff(rates[2, ]) <= 0))
# Installed compact inputs must recreate the exact shipped data without network.
source <- if (dir.exists("inst/data-build/USrecession")) {
  normalizePath("inst/data-build/USrecession")
} else {
  system.file("data-build", "USrecession", package = "AEC")
}
stopifnot(nzchar(source))
stage <- tempfile("us-rebuild-")
dir.create(file.path(stage, "data-raw"), recursive = TRUE)
dir.create(file.path(stage, "data"))
stopifnot(file.copy(source, file.path(stage, "data-raw"), recursive = TRUE))
old <- getwd()
setwd(stage)
sys.source("data-raw/USrecession/build.R", envir = new.env())
built <- new.env()
load("data/USrecession.rda", envir = built)
setwd(old)
stopifnot(identical(d, built$USrecession), file.info(file.path(stage, "data/USrecession.rda"))$size < 20000)
unlink(stage, recursive = TRUE)
