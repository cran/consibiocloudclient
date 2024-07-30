#' Get projects accessible to the user
#'
#' @description Get the projects accessible to the user from Consibio APIs.
#'
#' @return A matrix with the project information.
#' @importFrom magrittr `%>%`
#' @importFrom httr2 resp_body_json
#'
#' @details See details in https://api.v2.consibio.com/api-docs/#/default/get_projects
#' @export
#'
#' @examples
#' \dontrun{
#' get_projects()
#' }
get_projects <- function() {
  result <- client_req_perform("/projects", error_msg = "Failed to get projects")

  # Handle the result inside the conditional
  content <- result |> httr2::resp_body_json(auto_unbox = TRUE)

  content$payload
}
