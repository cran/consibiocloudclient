#' Get datalog for elements in project
#'
#' @description Get the datalog for multiple elements in a project from Consibio APIs.
#'
#' @param element_ids_to_fetch The element ids to fetch (`list`, Max 25).
#' @param from_time The from date (`POSIXct` or numeric).
#' @param to_time The to date (`POSIXct` or numeric).
#' @param interval The interval (optional, in seconds).
#' @param raw If TRUE, return the raw JSON response.
#'
#' @return A data frame with the datalog information.
#' @importFrom magrittr `%>%`
#' @importFrom httr2 resp_body_json
#' @importFrom utils URLencode
#'
#' @details See details in https://api.v2.consibio.com/api-docs/#/default/get_projects__project_id__datalog
#' @export
#'
#' @examples
#' \dontrun{
#' get_datalog(
#'   element_ids_to_fetch = c("{element_id}"),
#'   from_time = as.POSIXct("2021-01-01"), to_time = as.POSIXct("2021-01-02")
#' )
#' }
get_datalog <- function(
    element_ids_to_fetch = NULL,
    from_time = NULL,
    to_time = NULL,
    interval = NULL,
    raw = FALSE) {
  project_id <- get_project_id()

  # If it's time() we need to convert it to numeric
  if (inherits(from_time, "POSIXct") || inherits(from_time, "POSIXt")) {
    from_time <- as.numeric(from_time)
  }
  if (inherits(to_time, "POSIXct") || inherits(to_time, "POSIXt")) {
    to_time <- as.numeric(to_time)
  }

  # Check if both are a number and same length as a unix timestamp
  if (!is.numeric(from_time) || from_time < 0 || from_time > 9999999999) {
    halt("The from_time must be a unix timestamp.")
  }
  if (!is.numeric(to_time) || to_time < 0 || to_time > 9999999999) {
    halt("The to_time must be a unix timestamp.")
  }

  # If interval is not NULL, check if it's a number
  if (!is.null(interval) && (!is.numeric(interval) || interval < 0)) {
    halt("The interval must be a positive number.")
  }

  # If no elements, stop
  if (is.null(element_ids_to_fetch) || length(element_ids_to_fetch) == 0) {
    halt("You must provide at least one element id.")
  }

  # We'll let the API handle the normal validation, like valid period
  # However, the header are simply too long to handle in the API,
  # If the user try and query too many elements at once.
  # So we use the same limit as the API, which is 25
  if (length(element_ids_to_fetch) > 25) {
    halt("You can only fetch datalogs for 25 elements at a time.")
  }

  # Url start
  url <- paste0("/projects/", project_id, "/datalog")

  elements_url_safe <- sapply(element_ids_to_fetch, utils::URLencode, reserved = TRUE) |> paste(collapse = ";")
  url_params <- list(
    elements = elements_url_safe,
    from_time = from_time,
    to_time = to_time
  )

  # Transform url_params into a character vector of search params
  search_params <- paste0(names(url_params), "=", url_params, collapse = "&")

  # Append search params to the url
  url <- paste0(url, "?", search_params)

  result <- client_req_perform(url, error_msg = "Failed to get devices")

  # Handle the result inside the conditional
  content <- result |> httr2::resp_body_json(auto_unbox = TRUE)

  # Return the raw content if requested
  if (raw) {
    return(content)
  }

  # Return the data frame
  make_datalog_df(content)
}

# ' Makes dataframe from JSON response
# '
# ' @param content The content of the response.
# ' @return A data frame with the datalog information.
# '
# ' @examples
# ' \dontrun{
# ' make_datalog_df(content)
# ' }

make_datalog_df <- function(content) {
  # Convert payload to a data frame
  df <- data.frame(
    element_id = character(),
    value = character(),
    timestamp = character(),
    stringsAsFactors = FALSE
  )

  # Iterate over each key in the payload
  for (element_id in names(content$payload)) {
    # Get the array of values for the current key
    values <- content$payload[[element_id]]

    # Iterate over each item in the array
    for (item in values) {
      # Extract the value and time from the item
      value <- item$v
      timestamp <- item$t

      # Append the values to the data frame
      df <- rbind(df, data.frame(element_id = element_id, value = value, timestamp = timestamp))
    }
  }

  # Convert time column to `POSIXct` if not NULL or containing only NA values
  if (!is.null(df$timestamp) && !all(is.na(df$timestamp))) {
    df$timestamp <- as.POSIXct(df$timestamp, origin = "1970-01-01", tz = "UTC")
    # If you know the exact format of your timestamp, you can specify it like so:
    # df$timestamp <- as.POSIXct(df$timestamp, format = "%Y-%m-%d %H:%M:%S", origin = "1970-01-01", tz = "UTC")
  } else {
    halt("Datalog content contains invalid data. Timestamp column is NULL or contains only NA values.")
  }

  df
}
