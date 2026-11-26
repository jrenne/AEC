# Prevent uncleared data from accidentally returning to public releases.
expected <- c("CHaccidents", "CHaccidents_monthly", "CHvotes", "CHvotes_cantons",
  "UCIcredit", "CHelectricity", "CHelectricity_meters", "CHelectricity_annual",
  "USrecession", "CHapples", "CHapples_frost", "CHhydro", "FRradars", "FRaccidents_daily")
stopifnot(setequal(data(package="AEC")$results[, "Item"], expected))
sources <- read.csv(system.file("teaching-data/sources.csv", package="AEC"))
stopifnot(setequal(unique(unlist(strsplit(sources$datasets, ";", fixed=TRUE))), expected),
          all(nzchar(sources$data_terms)), all(nzchar(sources$credit)),
          identical(packageDescription("AEC")$License, "MIT + file LICENSE"),
          length(getNamespaceExports("AEC")) == 0L)
cat("PASS: release inventory contains only the fourteen reviewed datasets.\n")
