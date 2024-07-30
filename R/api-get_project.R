#' Get project information
#'
#' @description Get the project information from Consibio APIs.
#'
#' @param project_id The project id (optional).
#' @return A matrix with the project information.
#' @importFrom magrittr `%>%`
#' @importFrom httr2 resp_body_json
#'
#' @details See details in https://api.v2.consibio.com/api-docs/#/default/get_project
#' @export
#'
#' @examples
#' \dontrun{
#' get_project(project_id = "{project_id}")
#' }
get_project <- function(project_id = NULL) {
  if (is.null(project_id)) {
    project_id <- get_project_id()
  }
  is_valid_entity_id(entity_id = project_id, type = "project")

  result <- client_req_perform(paste0("/projects/", project_id), ,
    error_msg = "Failed to get project"
  )

  # Handle the result inside the conditional
  content <- result |> httr2::resp_body_json(auto_unbox = TRUE)

  content$payload
}
