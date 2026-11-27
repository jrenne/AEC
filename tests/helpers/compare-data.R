# Exact structure/counts/dates; elementwise floating-point tolerance only.
assert_same_teaching_data <- function(expected, actual) {
  expected_attributes <- attributes(expected)
  actual_attributes <- attributes(actual)
  stopifnot(
    setequal(names(expected_attributes), names(actual_attributes)),
    all(vapply(names(expected_attributes), function(name) {
      identical(
        expected_attributes[[name]], actual_attributes[[name]]
      )
    }, logical(1))),
    identical(names(expected), names(actual))
  )
  for (name in names(expected)) {
    x <- expected[[name]]
    y <- actual[[name]]
    if (is.double(x) && !is.object(x)) {
      stopifnot(
        identical(typeof(x), typeof(y)),
        identical(attributes(x), attributes(y)),
        identical(is.na(x), is.na(y)),
        identical(is.finite(x), is.finite(y))
      )
      finite <- is.finite(x)
      bound <- 64 * .Machine$double.eps * pmax(1, abs(x[finite]), abs(y[finite]))
      stopifnot(
        all(abs(x[finite] - y[finite]) <= bound),
        identical(x[!finite], y[!finite])
      )
    } else {
      stopifnot(identical(x, y))
    }
  }
  invisible(TRUE)
}
