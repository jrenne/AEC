# Run from AEC root; readxl is needed only for rebuilding, not for using data.
input <- "data-raw/UCIcredit/uci-350.zip"
expected <- "56c885f84457f6680f8438f02bfcdac9579323d8a94465ee5f26e32baa727602"
actual <- strsplit(system2("shasum", c("-a", "256", shQuote(input)), stdout = TRUE), " +")[[1]][1]
stopifnot(identical(actual, expected), requireNamespace("readxl", quietly = TRUE))
folder <- tempfile("uci-")
dir.create(folder)
input_xls <- unzip(input, exdir = folder)
UCIcredit <- as.data.frame(readxl::read_excel(input_xls, skip = 1))
original <- names(UCIcredit)
names(UCIcredit)[1] <- "borrower_id"
names(UCIcredit)[25] <- "default_next_month"
stopifnot(
  nrow(UCIcredit) == 30000L, ncol(UCIcredit) == 25L,
  !anyDuplicated(UCIcredit$borrower_id), !anyNA(UCIcredit),
  all(UCIcredit$default_next_month %in% 0:1),
  sum(UCIcredit$default_next_month) == 6636
)
save(UCIcredit, file = "data/UCIcredit.rda", version = 2, compress = "xz")
mapping <- data.frame(
  dataset = "UCIcredit", variable = names(UCIcredit),
  source_or_transformation = original
)
write.csv(mapping, "data-raw/UCIcredit/column-mappings.csv", row.names = FALSE)
unlink(folder, recursive = TRUE)
