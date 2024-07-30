with_mock_dir(
  "../api/elements",
  test_that("get_elements() works", {
    # Get the elements_list from env, make list by separating by comma
    elements_list_raw <- get_env("ELEMENT_IDS")
    elements_list <- strsplit(elements_list_raw, ",")
    element_id <- prep_entity_id(elements_list[[1]][1])

    # Get project from env
    result <- get_elements()

    testthat::expect_type(result, "list")

    # Expect at least one key in the list
    testthat::expect_true(length(result) > 0)

    # Expect a device to be in the list
    testthat::expect_true(element_id %in% names(result))
  })
)
