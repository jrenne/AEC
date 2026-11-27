# Optional extraction from the complete, versioned article replication checkout.
# Run from the AEC package root; no file in the research checkout is modified.
package_root <- normalizePath(".")
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1L) stop("Supply the article replication checkout path.")
root <- normalizePath(args[1], mustWork = TRUE)
manifest <- jsonlite::fromJSON(file.path(package_root, "data-raw/FRradars/upstream-sha256.json"))
for (path in names(manifest)) {
  actual <- digest::digest(file.path(root, path), algo = "sha256", file = TRUE)
  stopifnot(identical(actual, manifest[[path]]))
}
setwd(root)
Sys.setenv(DR_RADII = "2", DR_BALANCED_EVENT_HORIZON = "12", DR_MIN_NETWORK_REACH_RATIO = ".75", DR_BOOTSTRAP_REPETITIONS = "2", PRIMARY_ESTIMATOR = "plain")
script <- readLines("codes/13_doubly_robust_road_corridor_did.R")
start <- grep("^estimate_radius <- function", script)
end <- grep("^  estimate_one <- function", script)
e <- new.env()
eval(parse(text = script[1:(start - 1)]), e)
e$radius <- 2
eval(parse(text = script[(start + 1):(end - 1)]), e)
built <- e$build_stack_data(e$accident_values, 1L, 12L)
d <- built$data
idx <- match(d$cle_radar, e$candidates$cle_radar)
treated_ids <- vapply(built$stacks, function(x) e$candidates$cle_radar[x$treated], character(1))
anchor_index <- e$candidates$installation_month[match(treated_ids, e$candidates$cle_radar)]
month_date <- function(x) as.Date(sprintf("%04d-%02d-01", x %/% 12L, x %% 12L + 1L))
pre <- (d$pre_12_7 + d$pre_6_1) / 2
FRradars <- data.frame(
  stack_id = as.integer(d$stack_id), site_id = d$cle_radar,
  treated = as.logical(d$treated), anchor_month = month_date(anchor_index[d$stack_id]),
  installation_month = month_date(e$candidates$installation_month[idx]),
  road_class = e$candidates$route_class[idx], speed_limit_kmh = e$candidates$vma_kmh[idx],
  accidents_earlier = as.integer(round(12 * d$pre_24_13)),
  accidents_pre = as.integer(round(12 * pre)),
  accidents_post = as.integer(round(12 * (pre + d$change)))
)
stopifnot(
  nrow(FRradars) > 406L, sum(FRradars$treated) == 406L,
  length(unique(FRradars$site_id)) == 639L,
  max(abs(12 * pre - FRradars$accidents_pre)) < 1e-9,
  max(abs(12 * (pre + d$change) - FRradars$accidents_post)) < 1e-9
)
score <- vapply(split(FRradars, FRradars$stack_id), function(z) {
  change <- (z$accidents_post - z$accidents_pre) / 12
  change[z$treated] - mean(change[!z$treated])
}, numeric(1))
paper <- subset(
  read.csv("results/cached/estimates_monthly_road_corridor_network_100m_balanced12_reach75.csv"),
  outcome == "accidents" & radius_km == 2 & window == "months_1_12"
)
stopifnot(abs(mean(score) - paper$estimate) < 1e-12)
print(c(rows = nrow(FRradars), stacks = sum(FRradars$treated), sites = length(unique(FRradars$site_id)), estimate = mean(score)))
print(range(FRradars$anchor_month))
print(range(FRradars$installation_month))
print(table(FRradars$road_class))
print(range(table(FRradars$stack_id) - 1))
output <- file.path(package_root, "data-raw/FRradars")
f <- gzfile(file.path(output, "stack-counts.csv.gz"), "wt")
write.csv(FRradars, f, row.names = FALSE)
close(f)
