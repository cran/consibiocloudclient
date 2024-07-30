library(httptest2)

# Affects sort order in CRAN
Sys.setlocale("LC_COLLATE", "C")

setup_test <- function() {
  # Throw error if DRY_RUN="true" and tests/api or tests/testthat/_snaps are found
  if (get_env("DRY_RUN") == "true") {
    if (dir.exists("../api") || dir.exists("_snaps")) {
      stop("Mocks already found, but DRY_RUN is set to true.
  Remove tests/api or tests/testthat/_snaps folders before running tests with DRY_RUN=true, or change .env file.")
    }
  } else if (!dir.exists("../api") || !dir.exists("_snaps")) {
    # Test if tests/api and tests/testthat/_snaps are found
    stop("No mocks found, but DRY_RUN is not set to true. Both tests/api or tests/testthat/_snaps needs to be present.
      Please run tests with DRY_RUN=true, by changing the .env file.")
  }

  # Skip if not installed
  testthat::skip_if_not_installed("httr2")
  testthat::skip_if_not_installed("httptest2")

  # Testing against the API with httptest2
  # Mocks are saved and some values are shortened (redacted)
  # Redactors can be added in: inst/httptest2/redact.R

  # Use the util to print "CONSIBIO_USERNAME" environment variable
  message("Username set to: ", get_username())

  # Print if password is also set
  if (nzchar(get_env("CONSIBIO_PASSWORD"))) message("Password also found in environment variables")

  # Setup options for test
  set_project_id(get_env("PROJECT_ID"))
}

setup_test()
