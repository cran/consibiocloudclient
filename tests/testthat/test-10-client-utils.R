test_that("client helper get_api_url", {
  # it's not possible to request a get_api_url without a tailing slash
  expect_error(get_api_url("users/me"))
})

test_that("client helper set_api_url", {
  # it's not possible to set a API url without http:// or https://
  expect_error(set_api_url("api.consibio.com"))

  # set a valid API url
  api_url <- get_api_url()
  set_api_url(api_url)

  # set default URL on call to get_api_url, if no url are set
  set_env("CONSIBIO_API_HOST", "")
  expect_true(get_api_url() != "")
  expect_true(get_env("CONSIBIO_API_HOST") != "")
})

test_that("client helper set_username", {
  # it's not possible to set_username with an invalid username
  expect_error(set_username("hi_bob"))
})

test_that("client helper client_req_auth", {
  # client_req_auth will set password as NULL if env variable CONSIBIO_PASSWORD is invalid
  # it's not possible to test, but it's possible to cover anyway
  prev_password_from_env <- get_env("CONSIBIO_PASSWORD")
  set_env("CONSIBIO_PASSWORD", "")
  expect_error(client_req_auth(req = NULL))
  set_env("CONSIBIO_PASSWORD", prev_password_from_env)
})

test_that("client helper is_client_resp_content_valid", {
  expect_true(is_client_resp_content_valid(list("status" = "ok", "time" = 123)))
  expect_true(is_client_resp_content_valid(list("status" = "ok", "payload" = list())))

  expect_false(is_client_resp_content_valid(list("status" = "ok")))
  expect_false(is_client_resp_content_valid(list("time" = 123)))
  expect_false(is_client_resp_content_valid(list("status" = "error", "time" = 123)))

  expect_error(is_client_resp_content_valid(NULL))
  expect_error(is_client_resp_content_valid(list("status" = "error", "payload" = list("error" = "This should fail"))))
})

test_that("client helper is_client_resp_error", {
  # is_client_resp_error can spot a error if we hit the wrong endpoint
  # let's test with null first
  expect_error(is_client_resp_error(NULL))
  # now let's the logics around the function
  expect_error(client_req_perform("/invalid_route", "GET"))
})
