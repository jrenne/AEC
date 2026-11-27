e <- new.env()
local <- file.exists("data/FRradars.rda")
if (local) load("data/FRradars.rda", envir = e) else utils::data("FRradars", package = "AEC", envir = e)
d <- e$FRradars
stopifnot(
  nrow(d) == 21939L, ncol(d) == 10L, !anyDuplicated(d[c("stack_id", "site_id")]),
  sum(d$treated) == 406L, length(unique(d$site_id)) == 639L,
  length(unique(d$site_id[!d$treated])) == 477L
)
idx <- function(date) as.integer(format(date, "%Y")) * 12L + as.integer(format(date, "%m")) - 1L
stopifnot(
  all(idx(d$installation_month[d$treated]) == idx(d$anchor_month[d$treated])),
  all(idx(d$installation_month[!d$treated]) > idx(d$anchor_month[!d$treated]) + 12L),
  all(d$accidents_pre >= 0L), all(d$accidents_post >= 0L), all(d$accidents_earlier >= 0L)
)
blocks <- split(d, d$stack_id)
for (b in blocks) {
  stopifnot(
    sum(b$treated) == 1L, sum(!b$treated) >= 10L,
    length(unique(b$road_class)) == 1L, length(unique(b$speed_limit_kmh)) == 1L,
    length(unique(b$anchor_month)) == 1L
  )
}
score <- vapply(blocks, function(b) {
  change <- (b$accidents_post - b$accidents_pre) / 12
  change[b$treated] - mean(change[!b$treated])
}, numeric(1))
# Independent benchmark from the article's cached baseline table (406 sites).
stopifnot(
  abs(mean(score) - (-0.014770945851140501)) < 1e-14,
  sum(d$accidents_pre[d$treated]) == 196L, sum(d$accidents_post[d$treated]) == 158L
)
root <- if (local) "inst" else system.file(package = "AEC")
m <- read.csv(file.path(root, "teaching-data/column-mappings.csv"))
stopifnot(setequal(names(d), m$variable[m$dataset == "FRradars"]))
folder <- tempfile("aec-radars-rebuild-")
dir.create(folder)
dir.create(file.path(folder, "data-raw"))
dir.create(file.path(folder, "data"))
stopifnot(file.copy(file.path(root, "data-build/FRradars"), file.path(folder, "data-raw"), recursive = TRUE))
old <- getwd()
setwd(folder)
tryCatch({
  rebuilt <- new.env()
  sys.source("data-raw/FRradars/build.R", envir = rebuilt)
  stopifnot(identical(d, rebuilt$FRradars))
}, finally = {
  setwd(old)
  unlink(folder, recursive = TRUE)
})
cat("PASS: radar sample, calendar eligibility, strata, article benchmark/counts, mappings and installed offline rebuild.\n")
