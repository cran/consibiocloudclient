with_mock_dir(
  "../api/devices",
  test_that("get_devices() works", {
    device_id <- prep_entity_id(get_env("DEVICE_ID"))

    result <- get_devices()

    testthat::expect_type(result, "list")

    # Expect at least one key in the list
    testthat::expect_true(length(result) > 0)

    # Expect a device to be in the list
    testthat::expect_true(device_id %in% names(result))
  })
)
