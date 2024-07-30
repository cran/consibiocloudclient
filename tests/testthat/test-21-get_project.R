with_mock_dir(
  "../api/project",
  test_that("get_project() works", {
    project_in_options <- prep_entity_id(get_project_id())
    # Get project
    result <- get_project()

    # Test the result is a list
    testthat::expect_type(result, "list")

    # Expect our project to be in the list
    testthat::expect_true(project_in_options %in% names(result))

    # Set project
    project <- result[[project_in_options]]

    # Access the project and get the "roles" Map
    roles <- project$roles

    # Current user
    user_id <- get_env("CONSIBIO_USER_ID")

    # Check if user_id is in the roles
    testthat::expect_true(user_id %in% names(roles))
  })
)
