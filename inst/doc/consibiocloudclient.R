## ----setup, include=FALSE-----------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  eval = FALSE
)

## -----------------------------------------------------------------------------
#  library(consibiocloudclient)
#  
#  # After loading our package, try and make a api status call.
#  result <- get_test()
#  status <- result$status
#  time <- result$time

## -----------------------------------------------------------------------------
#  login("bob@helloworld.com")

## -----------------------------------------------------------------------------
#  logout()

## -----------------------------------------------------------------------------
#  set_project_id(target_project)

## -----------------------------------------------------------------------------
#  options("consibio.project_id" = "your_project_id")

## -----------------------------------------------------------------------------
#  user <- get_users_me()

## -----------------------------------------------------------------------------
#  projects <- get_projects()

## -----------------------------------------------------------------------------
#  project <- get_project()

## -----------------------------------------------------------------------------
#  devices <- get_devices()

## -----------------------------------------------------------------------------
#  device <- get_device("your_device_id")

## -----------------------------------------------------------------------------
#  elements <- get_elements()
#  
#  # Get element ids
#  element_ids <- names(elements)

## -----------------------------------------------------------------------------
#  element <- get_element("your_element_id")

## -----------------------------------------------------------------------------
#  element_ids <- c("your_element_id_1", "your_element_id_2")
#  to_time <- Sys.time()
#  from_time <- to_time - 1 * 24 * 60 * 60 # 1 days
#  df <- get_datalog(element_ids, from_time, to_time)

## ----eval=FALSE---------------------------------------------------------------
#  library(consibiocloudclient)
#  
#  # Login
#  login("bob@helloworld.com") # This will shows a prompt to enter password. If you wan't to use a static password (not recommended), set CONSIBIO_PASSWORD as env. variable before trying to login
#  
#  # Get user
#  get_users_me()
#  
#  # Get projects
#  projects <- get_projects()
#  target_project <- names(projects)[1]
#  
#  # Set target project (can also be done with the native R function: options(consibio.project_id = target_project))
#  set_project_id(target_project)
#  
#  # Get project
#  project <- get_project()
#  
#  # Get devices
#  devices <- get_devices()
#  
#  # Get elements
#  elements <- get_elements()
#  
#  # Make list with elements
#  element_ids <- names(elements)
#  
#  # Limit the scope to maximum 25 elements, which are the maximum amount of elements that can be fetched at once
#  element_ids <- element_ids[1:25]
#  
#  # Get datalog
#  to_time <- Sys.time()
#  from_time <- to_time - 1 * 24 * 60 * 60 # 1 days
#  df <- get_datalog(element_ids, from_time, to_time)
#  
#  ############
#  # Element checks before plotting the data
#  ############
#  # Get the elements from the df without data, but was queried
#  elements_without_data <- c() # Initialize an empty vector to store the elements without data
#  # Loop over each element in element_ids If the element is not in df$element_id, add it to elements_without_data
#  for (element in element_ids)
#    if (!element %in% df$element_id)
#      elements_without_data <- c(elements_without_data, element)
#  # print(elements_without_data)
#  
#  # Find the elements in element_ids that are in df$element_id
#  elements_with_data <- setdiff(element_ids, elements_without_data)
#  # print(elements_with_data)
#  
#  # Print a single line statement with the total, with and without
#  sprintf(
#    "Got %d elements with data, and %d witout.",
#    length(elements_with_data),
#    length(elements_without_data)
#  )
#  
#  
#  ############
#  # Example on how to print a plot with the dataframe values, where we use the name and color of each fetched element
#  ############
#  # Create a data frame with the element IDs, names, and colors
#  df_element_default <- data.frame(
#    element_id = names(elements),
#    name = sapply(elements, function(x)
#      x$name),
#    color = sapply(elements, function(x)
#      x$color)
#  )
#  
#  # Merge the element data frame with the original data frame
#  df_extended <- merge(df, df_element_default, by = "element_id", all.x = TRUE)
#  
#  # df_extended <- df_extended[df_extended$element_id == "jedBIJcmzw6tGLKvmtbm",] # Limit to a single element, if you need to test something
#  
#  if (!require(ggplot2)) {
#    install.packages("ggplot2")
#  }
#  library(ggplot2)
#  
#  # Create a line plot with `ggplot2`
#  render_without_colors <- TRUE # If the colors are identical, or similar, the plot will replace the existing scales. If so, it's possible to render without the colors
#  if (render_without_colors) {
#    ggplot(df_extended,
#           aes(
#             x = timestamp,
#             y = value,
#             color = name,
#             group = element_id
#           )) +
#      geom_line() +
#      labs(title = "Consibio Cloud Plot", x = "Timestamp", y = "Value") +
#      theme(plot.title = element_text(hjust = 0.5)) +
#      scale_color_manual(
#        values = setNames(df_extended$color, df_extended$name),
#        guide = guide_legend(title = "Element Name")
#      ) +
#      scale_x_datetime(date_labels = "%Y-%m-%d %H:%M:%S")
#  } else{
#    ggplot(df_extended,
#           aes(
#             x = timestamp,
#             y = value,
#             color = color,
#             group = element_id
#           )) +
#      geom_line() +
#      labs(title = "Consibio Cloud Plot", x = "Timestamp", y = "Value") +
#      theme(plot.title = element_text(hjust = 0.5)) +
#      scale_color_identity() +
#      guides(color = guide_legend(title = "Element Name")) +
#      scale_color_discrete(labels = df_extended$name) +
#      scale_x_datetime(date_labels = "%Y-%m-%d %H:%M:%S")
#  }
#  
#  # Logout
#  logout() # Will remove username and user_id. Please reset your R-session to remove any tokens (which are saved automatically in memory)

