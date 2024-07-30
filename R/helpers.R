#' Halt execution and raise an error
#'
#' This function halts the execution of the program and raises an error with the provided message.
#'
#' @param ... Additional arguments to be passed to the `stop` function.
#' @noRd
#' @keywords internal
#' @examples
#' \dontrun{
#' halt("An error occurred.")
#' halt("An error occurred.", call. = FALSE)
#' halt(list("Error caused by something.", "Extra detail here."))
#' }
halt <- function(...) {
  args <- list(...)
  if (is.list(args[[1]])) {
    message <- do.call(paste, c(Filter(Negate(is.null), args[[1]]), sep = " "))
    stop(message, call. = FALSE)
  } else {
    stop(..., call. = FALSE)
  }
}


#' Get the Consibio project ID
#'
#' This function retrieves the Consibio project ID from the options.
#' If the project ID is not set or is an empty string, an error is thrown.
#'
#' @return The Consibio project ID
#' @export
#'
#' @examples
#' # Set the Consibio project ID
#' # Alternatively, you can use the set_project_id('PROJECT_ID') function
#' options(consibio.project_id = "PROJECT_ID")
#'
#' # Get the Consibio project ID
#' get_project_id()
get_project_id <- function() {
  # Get the project ID from the options
  project_id <- getOption("consibio.project_id")

  # Check if project_id is NULL or an empty string
  if (is.null(project_id) || project_id == "") {
    halt("Could not find Consibio Project ID. Set options with:
    'set_project_id('PROJECT_ID')'")
  }

  project_id
}

#' Set the Consibio project ID option
#' @param project_id The project ID to set.
#'
#' @return The project ID that was set.
#' @export
#' @examples
#' set_project_id("PROJECT_ID")
set_project_id <- function(project_id) {
  is_valid_entity_id(entity_id = project_id, type = "project")

  # Set the project ID in the options
  options(consibio.project_id = project_id)

  project_id
}

#' prep_entity_id will check if DRY_RUN = "true".
#' It will return the current value, else it will return the first 3 characters of the entity_id
#' This is used as a helper for our tests, with mocked data.
#' @param entity_id The entity id.
#' @noRd
#' @keywords internal
#' @return The (manipulated) entity id.
prep_entity_id <- function(entity_id) {
  if (get_env("DRY_RUN") == "true") {
    return(entity_id)
  }

  substr(entity_id, 1, 3)
}

#' Sets the environment variable with the given name and value.
#'
#' @param env_name The name of the environment variable.
#' @param env_value The value to be set for the environment variable.
#' @noRd
#' @keywords internal
#' @return The value that was set for the environment variable.
set_env <- function(env_name, env_value) {
  # Initialize a list with the environment value
  env_to_set <- list(env_value)

  # Assign the environment name as the name of the first element
  names(env_to_set) <- env_name

  # Use do.call to call Sys.setenv with the named vector as arguments
  do.call(Sys.setenv, env_to_set)

  env_value
}

#' Get the value of the environment variable with the given name.
#'
#' @param env_name The name of the environment variable.
#' @noRd
#' @keywords internal
#' @return The value of the environment variable.
get_env <- function(env_name) {
  value <- Sys.getenv(env_name)
  value
}

#' Load environment variables from a .env file
#'
#' This function loads environment variables from a .env file located in the current working directory.
#' The .env file should contain key-value pairs in the format "KEY=VALUE".
#'
#' @param file_path Set the path of the env file (default is ".env").
#' @noRd
#' @keywords internal
#' @return NULL
load_env_file <- function(file_path = ".env") {
  if (file.exists(file_path)) {
    dotenv::load_dot_env(file_path)
    return(TRUE)
  }

  FALSE
}
