#' Get device in project
#'
#' @description Get the project device in Consibio APIs.
#'
#' @param device_id The device id.
#' @return A matrix with the device information.
#' @importFrom magrittr `%>%`
#' @importFrom httr2 resp_body_json
#'
#' @details See details in https://api.v2.consibio.com/api-docs/#/default/get_projects__project_id__devices__device_id_
#' @export
#'
#' @examples
#' \dontrun{
#' get_device(device_id = "{device_id}")
#' }
get_device <- function(device_id = NULL) {
  is_valid_entity_id(entity_id = device_id, type = "device")
  project_id <- get_project_id()

  result <- client_req_perform(paste0("/projects/", project_id, "/devices/", device_id),
    error_msg = "Failed to get device"
  )

  # Handle the result inside the conditional
  content <- result |> httr2::resp_body_json(auto_unbox = TRUE)

  content$payload
}
