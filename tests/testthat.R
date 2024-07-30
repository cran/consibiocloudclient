start_test <- function() {
  if (!requireNamespace("testthat", quietly = TRUE)) {
    message("testthat package is not installed, please install it before running tests.")
    return()
  }

  library(testthat)
  test_check("consibiocloudclient")
}

library(consibiocloudclient)

start_test()
