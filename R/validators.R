#' Is valid entity ID
#'
#' @param entity_id The entity ID
#' @param type The type of the entity ID. Default is 'project' (will just change the halt error message)
#' @export
#' @return TRUE if the entity ID is valid, FALSE otherwise
#' @examples
#' \dontrun{
#' is_valid_entity_id("123456", "project")
#' }
is_valid_entity_id <- function(entity_id = NULL, type = NULL) {
  # Check if project_id is NULL or a empty string
  if (is.null(entity_id) || entity_id == "") {
    if (!is.null(type) && type != "") {
      # First letter of the type need to be uppercase
      type <- tolower(type)
      type <- paste0(toupper(substring(type, 1, 1)), substring(type, 2))
      halt(paste0(type, " ID needs to be a non-empty string."))
    } else {
      halt("Entity ID needs to be a non-empty string.")
    }
  }

  TRUE
}


#' Check if a username is valid.
#'
#' By using regular expressions, this function checks if a username is a valid email address.
#'
#' @param username The username to be checked.
#'
#' @return TRUE if the username is valid, otherwise an error is thrown.
#'
#' @examples
#' is_valid_username("john.doe@example.com")
#' \dontrun{
#' is_valid_username("invalid_username")
#' is_valid_username("")
#' is_valid_username(NULL)
#' }
#'
#' @export
is_valid_username <- function(username = NULL) {
  # Check if username is NULL or an empty string
  if (is.null(username) || username == "") {
    # Return error
    halt("Username needs to be a non-empty string.")
  }

  # Check if username is a valid email address
  if (!grepl("^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Z|a-z]{2,}$", username)) {
    halt("Invalid username. Please provide a valid email address.")
  }

  TRUE
}
