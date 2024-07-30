test_that("if_invalid_credentials() works", {
  # Use simpleError to create an error object with the message
  e <- simpleError("Invalid credentials", call = NULL)

  # Set username
  email <- "bob@helloworld.com"
  set_username(email)

  # Check that CONSIBIO_USERNAME is set
  expect_equal(get_username(), email)

  expect_true(if_invalid_credentials(e))

  # Expect the username to be reset
  expect_equal(get_username(), "")
})
