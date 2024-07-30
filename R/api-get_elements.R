#' Get elements accessible to the user
#'
#' @description Get the projects elements to the user from Consibio APIs.
#'
#' @return A matrix with the project information.
#' @importFrom magrittr `%>%`
#' @importFrom httr2 resp_body_json
#'
#' @details See details in https://api.v2.consibio.com/api-docs/#/default/get_projects__project_id__elements
#' @export
#'
#' @examples
#' \dontrun{
#' get_elements()
#' }
get_elements <- function() {
  project_id <- get_project_id()

  result <- client_req_perform(paste0("/projects/", project_id, "/elements"), error_msg = "Failed to get elements")

  # Handle the result inside the conditional
  content <- result |> httr2::resp_body_json(auto_unbox = TRUE)

  content$payload
}
