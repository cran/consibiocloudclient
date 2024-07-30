#' Get the user information
#'
#' @description Get the user information from Consibio APIs.
#'
#'
#' @return A matrix with the user information.
#' @importFrom magrittr `%>%`
#' @importFrom httr2 resp_body_json
#'
#' @details See details in https://api.v2.consibio.com/api-docs/#/default/get_users_me
#' @export
#'
#' @examples
#' \dontrun{
#' get_users_me()
#' }
get_users_me <- function() {
  result <- client_req_perform("/users/me", error_msg = "Failed to get Users Me")

  # Handle the result inside the conditional
  content <- result |> httr2::resp_body_json(auto_unbox = TRUE)

  content$payload
}
