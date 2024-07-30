#' Login to Consibio API
#'
#' Use username to login to the Consibio API. Password will be requested interactively, now and once the token expires.
#' It sets the default username for authenticated requests.
#'
#' @param username A character string representing the username.
#' @return A character string representing the logged-in username.
#'
#' @examples
#' \dontrun{
#' login("bob@helloworld.com")
#' }
#'
#' @export
login <- function(username = NULL) {
  # Set the default username
  set_username(username)

  # Get /users/me as it will auto-fetch token, and return of "me"
  result <- NULL

  tryCatch(
    {
      result <- get_users_me()
    },
    error = function(e) {
      # If error is about invalid credentials, set username to blank
      if_invalid_credentials(e)

      # Throw error
      stop("An error occurred: ", conditionMessage(e))
    }
  )

  # Get the first name of result
  user_id <- names(result)[1]

  # Set the user_id as env
  set_env("CONSIBIO_USER_ID", user_id)

  result
}

#' Logout by removing the username and cached token
#' @export
#' @examples
#' logout()
#' @returns TRUE
logout <- function() {
  # Clear the username
  set_username(set_blank = TRUE)

  message("Please restart your R session to remove the cached token.")

  TRUE
}


#' Get API URL from environment variable
#'
#' This function retrieves the API URL from the environment variable named "CONSIBIO_API_HOST", if it is set.
#' If the environment variable is not set, it set and returns a default URL.
#' Optionally, it can append a path to the URL.
#'
#' @param path A character string representing the API URL.
#' @return A character string representing the API URL.
#' @export
#'
#' @examples
#' \dontrun{
#' get_api_url("/users/me")
#' }
#'
get_api_url <- function(path = NULL) {
  api_url <- Sys.getenv("CONSIBIO_API_HOST")

  # Path should start with a slash
  if (!is.null(path) && !grepl("^/", path)) {
    halt("Invalid path. Please provide a valid path starting with '/'.")
  }

  if (is.null(api_url) || api_url == "") {
    api_url <- "https://api.v2.consibio.com"
    message("CONSIBIO_API_HOST environment variable not set. Setting and using default URL: ", api_url)
    # Set the default URL
    set_api_url(api_url)
  }

  if (!missing(path)) {
    api_url <- paste0(api_url, path)
  }

  api_url
}

#' Set API URL in environment variable
#'
#' This function sets the API URL in the environment variable named "CONSIBIO_API_HOST".
#'
#' @param url A character string representing the API URL.
#' @export
#'
#' @examples
#' \dontrun{
#' set_api_url("https://api.v2.consibio.com")
#' }
#'
#' @return A character string representing the API URL.
set_api_url <- function(url = NULL) {
  # Check if it's a valid URL
  if (!is.null(url) && !grepl("^https?://", url)) {
    halt("Invalid URL. Please provide a valid URL starting with 'http://' or 'https://'.")
  }

  Sys.setenv("CONSIBIO_API_HOST" = url)

  get_api_url()
}

#' Set default username for authenticated requests
#'
#' This function sets the default username for authenticated requests.
#'
#' @param username A character string representing the username.
#' @param set_blank A logical value indicating whether to set the username to blank.
#' @noRd
#' @keywords internal
#' @examples
#' \dontrun{
#' set_username("bob@helloworld.com")
#' }
#'
#' @return A character string representing the default username.
set_username <- function(username = NULL, set_blank = FALSE) {
  # If set_blank is true, set username to blank
  if (set_blank) {
    username <- ""

    # Reset user id env
    set_env("CONSIBIO_USER_ID", "")
  } else {
    # Check if username is valid, will halt if not
    is_valid_username(username)
  }

  set_env("CONSIBIO_USERNAME", username)
  message("Username set to: ", username)
  get_username()
}

#' Get username from environment variable
#' @noRd
#' @keywords internal
#'
#' @return A character string representing the username.
#'
#' @examples
#' \dontrun{
#' get_username()
#' }
get_username <- function() {
  Sys.getenv("CONSIBIO_USERNAME")
}

#' Create an OAuth client for authentication
#'
#' This function creates an OAuth client object that can be used for authentication
#' with the Consibio API.
#' @importFrom httr2 oauth_client
#' @noRd
#' @keywords internal
#' @return An OAuth client object.
client_for_oauth <- function() {
  httr2::oauth_client(
    id = "R_PACKAGE_CLIENT",
    token_url = get_api_url("/oauth/token"),
    name = "consibio-client-api-session"
  )
}

#' Authenticate the request with the OAuth client
#' @importFrom httr2 req_oauth_password
#' @keywords internal
#' @param req The request object to authenticate.
#' @importFrom httr2 req_oauth_password
#' @return The authenticated request object.
client_req_auth <- function(req) {
  # Get the username from the environment variable
  username <- get_username()

  # If the username is not set, stop
  if (username == "") {
    halt("You are not authorized to access this endpoint. Please login first.")
  }

  # Try and see if CONSIBIO_PASSWORD is set
  password <- get_env("CONSIBIO_PASSWORD")

  # If password is not NULL, add it to the arguments list
  if (!is.null(password) && password == "") {
    password <- NULL
  }

  # Use do.call to pass the arguments list to req_oauth_password
  httr2::req_oauth_password(
    req = req,
    client = client_for_oauth(),
    username = username,
    password = password
  )
}

#' Helper to perform a request with and without auth, which result
#' can be used for further processing.
#'
#' @param path A character string representing the path to the API endpoint.
#' @param body Optional body to be sent with the request.
#' @param method A character string representing the HTTP method.
#' Supported methods are 'GET', 'POST', 'PATCH', 'DELETE'.
#' @param auth A logical value indicating whether to authenticate the request.
#' Will normally be automatically set to TRUE or FALSE.
#' @param error_msg A character string representing the error message to halt with.
#' @noRd
#' @keywords internal
#' @return A list with the result of the request.
#' @importFrom httr2 request req_body_json req_method req_perform
#' @examples
#' \dontrun{
#' req_perform("/test")
#' req_perform("/users/me")
#' req_perform("/users/me", method = "POST", body = list(full_name = "Bob Bob"))
#' req_perform("/test", auth = FALSE)
#' }
client_req_perform <- function(
    path,
    body = NULL,
    method = "GET",
    auth = TRUE,
    error_msg = NULL) {
  # If path is one of many, set auth to FALSE
  no_auth_paths <- c("/test", "/")

  if (path %in% no_auth_paths) {
    auth <- FALSE
  }

  # Create the request object
  req <- httr2::request(get_api_url(path))

  # POST, PATH AND DELETE are planned to be supported in the future
  # # Add body if provided
  # if (!is.null(body)) {
  #   # Test if body is a list
  #   if (!is.list(body)) {
  #     halt("Body must be a list. It's converted to JSON.")
  #   }

  #   req |>
  #     httr2::req_body_json(body)
  # }

  # # If method is PATCH, set the method to PATCH
  # if (method == "PATCH") {
  #   # Check if body is a list
  #   if (is.null(body)) {
  #     halt("Body must be a list for PATCH requests.")
  #   }
  #   req |>
  #     httr2::req_method("PATCH")
  # }

  # # If method is DELETE, set the method to DELETE
  # if (method == "DELETE") {
  #   # Secure that no body is sent with DELETE
  #   if (!is.null(body)) {
  #     halt("No body should be sent with DELETE requests.")
  #   }
  #   req |>
  #     httr2::req_method("DELETE")
  # }

  # If auth is TRUE, authenticate the request
  if (auth) {
    req <- client_req_auth(req)
  }

  # Perform the request
  # If you encounter problems, try and wrap the httr2 logics with httr2::with_verbosity()
  result <- NULL
  tryCatch(
    {
      result <- req |> httr2::req_perform()
    },
    error = function(e) {
      # Allow 404 to continue, else throw error
      halt("An error occurred: ", conditionMessage(e))
    }
  )

  is_client_resp_error(result, error_msg)

  # Return the result
  result
}


#' Helper to test if response contains errors. Used to test Consibio Cloud Client responses.
#' @importFrom httr2 resp_is_error
#' @param result The result of the request.
#' @param error_msg String with message to halt with if error.
#' @return A logical value indicating whether the response is an error.
#' @noRd
#' @keywords internal
#' @examples
#' \dontrun{
#' resp_is_error(result)
#' }
is_client_resp_error <- function(result, error_msg = NULL) {
  if (is.null(result)) {
    halt(list(error_msg, "No result in response. Please check the status page for the API."))
  }

  content <- httr2::resp_body_json(result)

  # Check if status is "ok" in content OR If payload is not defined, stop
  # Our test-endpoint does not respond with "payload", as all other endpoints
  is_client_resp_content_valid(content, error_msg)
}

#' Helper to check if content in response looks like valid data
#'
#' @param content The content of the response.
#' @param error_msg String with message to halt with if error.
#' @return A logical value indicating whether the content is valid.
#' @noRd
#' @keywords internal
#' @examples
#' \dontrun{
#' is_client_resp_content_valid(content)
#' }
is_client_resp_content_valid <- function(content, error_msg = NULL) {
  # If no content
  if (is.null(content)) {
    halt(list(error_msg, "No content in response. Please check the status page for the API."))
  }

  # If payload exists and there's a "error" key, return FALSE
  if (!is.null(content$payload) && !is.null(content$payload$error)) {
    halt(list(error_msg, "Error returned from API: ", content$payload$error))
  }

  if (is.null(content$status) || content$status != "ok") {
    return(FALSE)
  }

  # Check if payload or time is defined
  if (is.null(content$payload) && is.null(content$time)) {
    return(FALSE)
  }

  TRUE
}

#' Helper to check if error message is about invalid credentials
#' @param e The error object.
#'
#' @noRd
#' @keywords internal
#'
#' @return A logical value indicating whether the error message is about invalid credentials.
#' @examples
#' \dontrun{
#' is_valid_username(e)
#' }
if_invalid_credentials <- function(e) {
  if (grepl("invalid credentials", tolower(conditionMessage(e)))) {
    set_username(set_blank = TRUE)
    return(TRUE)
  }

  FALSE
}
