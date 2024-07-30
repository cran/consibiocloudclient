#' Get element information
#'
#' @description Get the element information from Consibio APIs.
#'
#' @param element_id The element id.
#' @return A matrix with the element information.
#' @importFrom magrittr `%>%`
#' @importFrom httr2 resp_body_json
#'
#' @details See details in https://api.v2.consibio.com/api-docs/#/default/get_projects__project_id__elements__entity_id_
#' @export
#'
#' @examples
#' \dontrun{
#' get_element(element_id = "{element_id}")
#' }
get_element <- function(element_id = NULL) {
  is_valid_entity_id(entity_id = element_id, type = "element")
  project_id <- get_project_id()

  result <- client_req_perform(paste0("/projects/", project_id, "/elements/", element_id),
    error_msg = "Failed to get element"
  )

  # Handle the result inside the conditional
  content <- result |> httr2::resp_body_json(auto_unbox = TRUE)

  content$payload
}
