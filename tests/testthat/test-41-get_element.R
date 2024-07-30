with_mock_dir(
  "../api/element",
  test_that("get_element() works", {
    # Get the elements_list from env, make list by separating by comma
    elements_list_raw <- get_env("ELEMENT_IDS")
    elements_list <- strsplit(elements_list_raw, ",")
    element_id <- prep_entity_id(elements_list[[1]][1])

    result <- get_element(element_id)

    testthat::expect_type(result, "list")

    # Expect at least one key in the list
    testthat::expect_true(length(result) > 0)

    # Expect the device to be in the list
    testthat::expect_true(element_id %in% names(result))
  })
)
