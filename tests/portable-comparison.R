source(if (file.exists("tests/helpers/compare-data.R")) "tests/helpers/compare-data.R" else "helpers/compare-data.R")
x <- data.frame(id = 1:2, value = c(0.1, 100), day = as.Date(c("2023-01-01", "2023-01-02")))
y <- x
y$value[1] <- x$value[1] + .Machine$double.eps
assert_same_teaching_data(x, y)
for (name in c("value", "id", "day")) {
  y <- x
  y[[name]][1] <- y[[name]][1] + 1
  stopifnot(inherits(try(assert_same_teaching_data(x, y), silent = TRUE), "try-error"))
}
y <- x
y$value[1] <- NA_real_
stopifnot(inherits(try(assert_same_teaching_data(x, y), silent = TRUE), "try-error"))
