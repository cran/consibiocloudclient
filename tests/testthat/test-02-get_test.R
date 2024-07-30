with_mock_dir(
  "../api/test",
  test_that("get_test() works", {
    result <- get_test()

    # Is a list
    testthat::expect_type(result, "list")

    # Has "status" and "time" keys
    testthat::expect_true("status" %in% names(result))
    testthat::expect_true("time" %in% names(result))
  })
)
