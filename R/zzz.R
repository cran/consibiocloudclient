.onAttach <- function(libname, pkgname) {
  # Load .env file if found
  load_env_file()
}

.onDetach <- function(libpath) {
  Sys.unsetenv("CONSIBIO_API_HOST")
  Sys.unsetenv("CONSIBIO_USERNAME")
  Sys.unsetenv("CONSIBIO_PASSWORD")
  Sys.unsetenv("CONSIBIO_USER_ID")
}
