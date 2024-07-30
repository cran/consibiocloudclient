with_mock_dir(
  "../api/device",
  test_that("get_device() works", {
    device_id <- prep_entity_id(get_env("DEVICE_ID"))

    result <- get_device(device_id)

    testthat::expect_type(result, "list")

    # Expect at least one key in the list
    testthat::expect_true(length(result) > 0)

    # Expect the device to be in the list
    testthat::expect_true(device_id %in% names(result))
  })
)

with_mock_dir(
  "../api/device_err",
  test_that("get_device() can fail if invalid device id", {
    # Expect an error
    testthat::expect_snapshot_error(get_device("not_a_device_id"))
  })
)
