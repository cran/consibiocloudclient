with_mock_dir(
  "../api/datalog",
  test_that("get_datalog() works", {
    # Get the elements_list from env, make list by separating by comma
    elements_list_raw <- get_env("ELEMENT_IDS")
    elements_list <- strsplit(elements_list_raw, ",")
    element_id <- prep_entity_id(elements_list[[1]][1])

    # Get new time with:
    # to_time <- Sys.time()
    # from_time <- to_time - 1 * 24 * 60 * 60 # 1 days
    # We use a static time, to prevent the mock to be generated every time,
    # as that will result in a new unique timestamp
    # Make POSIXct from timestamp
    from_time_date <- as.POSIXct(1720961617.4103, tz = "UTC")
    from_time_numeric <- as.numeric(from_time_date)
    to_time_date <- as.POSIXct(1721048017.4103, tz = "UTC")
    to_time_numeric <- as.numeric(to_time_date)

    result <- get_datalog(elements_list, from_time_numeric, to_time_numeric)

    # 'result' is a data frame
    testthat::expect_true(is.data.frame(result), "Result is not a data frame")

    # it works with POSIXct
    result_with_date <- get_datalog(elements_list, from_time_date, to_time_date)

    # it works with raw data
    result_raw <- get_datalog(elements_list, from_time_numeric, to_time_numeric, raw = TRUE)
    expect_true(is.list(result_raw), "Result is not a list")

    # it fails with a invalid interval
    expect_snapshot_error(get_datalog(elements_list, to_time_numeric, from_time_numeric, interval = "no_bob_number"))

    # it fails with a invalid from_time
    expect_snapshot_error(get_datalog(elements_list, "no_bob_number", to_time_numeric))

    # it fails with a invalid to_time
    expect_snapshot_error(get_datalog(elements_list, from_time_numeric, "no_bob_number"))

    # Try and query datalog without a elements_list
    expect_snapshot_error(get_datalog(NULL, from_time_numeric, to_time_numeric))

    # Try and query datalog with more than 25 elements
    elements_list <- rep(elements_list[[1]], 26)
    expect_snapshot_error(get_datalog(elements_list, from_time_numeric, to_time_numeric))

    # existence of expected columns (e.g., 'column_name')
    # Replace 'column_name' with actual column names you expect in 'result'
    err_msg <- "Expected columns are missing in the result"
    testthat::expect_true(all(c("element_id", "value", "timestamp") %in% names(result)), err_msg)

    # Test that element_id can be found in dataframe
    testthat::expect_true(element_id %in% result$element_id, "element_id not found in result")
  })
)

test_that("make_datalog_df will fail with invalid content", {
  # it fails with a invalid content
  expect_snapshot_error(make_datalog_df(NULL))
  expect_snapshot_error(make_datalog_df(list()))
})
