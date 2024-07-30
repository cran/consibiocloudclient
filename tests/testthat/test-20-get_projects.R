with_mock_dir(
  "../api/projects",
  test_that("get_projects() works", {
    project_in_options <- prep_entity_id(get_project_id())
    result <- get_projects()

    testthat::expect_type(result, "list")

    # Expect at least one key in the list
    testthat::expect_true(length(result) > 0)

    # Expect the project to be find in projects list
    testthat::expect_true(project_in_options %in% names(result))
  })
)
