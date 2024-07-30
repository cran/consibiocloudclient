with_mock_dir(
  "../api/login_error",
  test_that("login() can fail if invalid credentials", {
    # Save username and password for later
    prev_username_from_env <- get_username()
    prev_password_from_env <- get_env("CONSIBIO_PASSWORD")

    # Clear the environment
    set_env("CONSIBIO_USERNAME", "")

    # Expect CONSIBIO_USERNAME to be empty
    testthat::expect_equal(get_username(), "")

    # Login will set "CONSIBIO_USERNAME" and fetch users/me
    # Set CONSIBIO_PASSWORD env
    set_env("CONSIBIO_PASSWORD", "invalid_password")

    invalid_username <- "invalid_username_in_r_test@consibio.com"
    expect_error(
      login(
        username = invalid_username
      )
    )

    # Expect CONSIBIO_USERNAME to be empty
    # On test runs, the login are not actually handled.
    # Therefore, we actually expect the username from the failed test
    if (get_env("DRY_RUN") == "true") {
      testthat::expect_equal(get_username(), "")
    } else {
      testthat::expect_equal(get_username(), invalid_username)
    }

    # Restore the username and password to the previous values
    set_env("CONSIBIO_USERNAME", prev_username_from_env)
    set_env("CONSIBIO_PASSWORD", prev_password_from_env)
  }),
  simplify = FALSE
)


with_mock_dir(
  "../api/login",
  test_that("login() works", {
    # Save username for later
    prev_username_from_env <- get_username()

    # Clear the environment
    set_env("CONSIBIO_USERNAME", "")

    # Expect CONSIBIO_USERNAME to be empty
    testthat::expect_equal(get_username(), "")

    # Login will set "CONSIBIO_USERNAME" and fetch users/me
    result <- login(
      username = prev_username_from_env
    )

    # Expect the CONSIBIO_USERNAME to be set
    testthat::expect_equal(get_username(), prev_username_from_env)

    # get_users_me tests will test the result, so limit the test amount
    testthat::expect_type(result, "list")

    user_id <- names(result)[1]

    # Expect the user_id to be a string
    testthat::expect_type(user_id, "character")

    # Expect that there's only one key in the map
    testthat::expect_length(names(result), 1)

    # Expect that email is the same as CONSIBIO_USERNAME
    testthat::expect_equal(result[[user_id]]$email, prev_username_from_env)
  }),
  simplify = FALSE
)
