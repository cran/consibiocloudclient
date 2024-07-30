#' Consibio APIs status by calling the test endpoint
#'
#' @description Get the status of requests directly at Consibio APIs. Does not require authentication.
#'
#' @importFrom magrittr `%>%`
#'
#' @return A list with the status of the API and the time of the request.
#' @importFrom httr2 resp_check_status resp_body_json
#'
#' @details See details in https://api.v2.consibio.com/api-docs/#/default/get_test
#' @export
#'
#' @examples
#' \dontrun{
#' c_get_test()
#' }
get_test <- function() {
  result <- client_req_perform(path = "/test", error_msg = "Failed to get test")

  # Check status
  httr2::resp_check_status(result)

  # Parse the content
  content <- httr2::resp_body_json(result)

  # Extract the part about the API status
  status <- content$status
  time <- content$time

  # Make the list
  api_status <- list(status = status, time = time)

  # Return the list
  api_status
}
