test_that(".onDetach unsets environment variables", {
  # Set environment variables
  value <- "bob_was_here"

  # Set variables
  env_vars <- c("CONSIBIO_API_HOST", "CONSIBIO_USERNAME", "CONSIBIO_PASSWORD", "CONSIBIO_USER_ID")
  for (var in env_vars) {
    set_env(var, value)
  }

  # Ensure environment variables are set
  for (var in env_vars) {
    expect_true(!is.null(get_env(var)))
  }

  # Programmatically detach the package
  detach("package:consibiocloudclient", unload = TRUE)

  # Check if environment variables are unset
  for (var in env_vars) {
    expect_equal(get_env(var), "")
  }
})
