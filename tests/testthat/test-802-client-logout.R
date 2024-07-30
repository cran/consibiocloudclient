test_that("logout() can reset the username", {
  # Clear the environment
  set_env("CONSIBIO_USERNAME", "bob@helloworld.com")

  # Logout will reset the "CONSIBIO_USERNAME"
  logout()

  # Expect CONSIBIO_USERNAME to be empty
  testthat::expect_equal(get_username(), "")

  # Expect the user id to be empty
  testthat::expect_equal(get_env("CONSIBIO_USER_ID"), "")
})

with_mock_dir(
  "../api/logout",
  test_that("logout() works and get_users_me will throw error", {
    testthat::expect_snapshot_error(get_users_me())
  }),
  simplify = FALSE
)
