test_that("helpers get_project_id", {
  # Get current project id
  project_id <- get_project_id()

  # Expect a string with length > 0
  expect_true(is.character(project_id))

  # Set a new project id
  new_value <- "654321"
  options(consibio.project_id = new_value)

  # Get the new project id
  new_project_id <- get_project_id()

  # Expect the new project id
  expect_equal(new_project_id, new_value)

  # Set invalid project id
  options(consibio.project_id = "")

  # Expect a error
  expect_error(get_project_id())

  # Set the project id back to the original value
  options(consibio.project_id = project_id)
})

test_that("helpers halt", {
  expect_error(halt("This is a test"))
})

test_that("helpers prep_entity_id", {
  prev_dry_run <- get_env("DRY_RUN")

  set_env("DRY_RUN", "false")

  # Can prep our entity and user values, due to test data
  if (get_env("DRY_RUN") != "true") {
    testthat::expect_equal(prep_entity_id("1234567890"), "123")
  }

  # Set DRY_RUN to true
  set_env("DRY_RUN", "true")

  if (get_env("DRY_RUN") == "true") {
    testthat::expect_equal(prep_entity_id("1234567890"), "1234567890")
  }

  set_env("DRY_RUN", prev_dry_run)
})

test_that("helpers load_env_file", {
  # Will return false as file is not found
  expect_false(load_env_file(".env.non_existent"))

  # Get the current username, if any
  prev_username <- get_username()

  # Validate the username is not blank
  expect_true(nchar(prev_username) > 0)

  # Clear the username
  set_username(set_blank = TRUE)

  # Validate the username is blank
  expect_equal(get_username(), "")

  # Make a temp file
  temp_file <- tempfile()
  cat(paste0(
    "CONSIBIO_USERNAME=",
    prev_username,
    "\n"
  ), file = temp_file)
  load_env_file(temp_file)

  # Expect the username to be set
  expect_equal(get_username(), prev_username)

  # Cleanup the temp file
  unlink(temp_file)
})
