with_mock_dir(
  "../api/user_me",
  test_that("get_users_me() works", {
    result <- get_users_me()

    # The endpoint will return the user, in a Map.
    # The Map will only contain the current logged in user ("Me").
    # Is a list
    testthat::expect_type(result, "list")

    # We don't know the User ID, but that will be the key of the nested Map
    # Get the first key of the map
    user_id <- names(result)[1]

    # Expect that there's only one key in the map
    testthat::expect_length(names(result), 1)

    # Get the list of keys of the user
    user_obj_keys <- names(result[[user_id]])

    testthat::expect_true("full_name" %in% user_obj_keys)
    testthat::expect_true("last_login" %in% user_obj_keys)
    testthat::expect_true("email" %in% user_obj_keys)
    ## Check that email is same as CONSIBIO_USERNAME
    testthat::expect_equal(result[[user_id]]$email, get_username())
  })
)
