# If no DRY_RUN, set environment variables
if (Sys.getenv("DRY_RUN") != "true") {
  # Keep these updated, so they're not more than the ones in .env.example
  Sys.setenv("CONSIBIO_USERNAME" = "api-test-user@consibio.com")
  Sys.setenv("CONSIBIO_PASSWORD" = "SECRET_GOES_HERE")
  Sys.setenv("PROJECT_ID" = "LIFwyMfBedzy4uDhs7oF")
  Sys.setenv("ELEMENT_IDS" = "j20qIRbLQfJbxSyXC3wi,WcFMk5jTprzruuvfChUC")
  Sys.setenv("DEVICE_ID" = "eQ7yov1fBvjhhTNYOuTF")
} else {
  message("DRY_RUN is set to true, skipping set of test-specific environment variables.")
}
