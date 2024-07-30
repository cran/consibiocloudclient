test_that("validators is_valid_entity_id", {
  # Check invalid project id
  testthat::expect_error(is_valid_entity_id(NULL))

  # Check invalid project id
  testthat::expect_error(is_valid_entity_id(""))

  # Check valid project id
  testthat::expect_true(is_valid_entity_id("123456"))

  # Check that stop is called on invalid value and message
  testthat::expect_error(is_valid_entity_id("123456", stop = TRUE, message = "Invalid project ID"))

  # Check that a empty entity_id but type are set will throw a error
  testthat::expect_error(is_valid_entity_id("", "project"))
})

test_that("validators is_valid_username", {
  # Test that it's not possible to set a invalid username
  expect_error(is_valid_username(""))
  expect_error(is_valid_username("a"))
  expect_error(is_valid_username("a@"))
})
