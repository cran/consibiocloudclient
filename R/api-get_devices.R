#' Get devices in project
#'
#' @description Get the project devices in Consibio APIs.
#'
#' @return A matrix with the devices information.
#' @importFrom magrittr `%>%`
#' @importFrom httr2 resp_body_json
#'
#' @details See details in https://api.v2.consibio.com/api-docs/#/default/get_projects__project_id__devices
#' @export
#'
#' @examples
#' \dontrun{
#' get_devices()
#' }
get_devices <- function() {
  project_id <- get_project_id()

  result <- client_req_perform(paste0("/projects/", project_id, "/devices"), error_msg = "Failed to get devices")

  # Handle the result inside the conditional
  content <- result |> httr2::resp_body_json(auto_unbox = TRUE)

  content$payload
}
