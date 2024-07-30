function(response) {
  require(magrittr, quietly = TRUE)
  response %>%
    # Shorten the URL
    gsub_response("https\\://api.v2.consibio.com/", "v2/") %>%
    # Shorten UUID's to first 3 characters
    gsub_response("([0-9a-zA-Z]{3})[0-9a-zA-Z]{17}", "\\1") %>%
    # Remove access_token value from JSON response
    gsub_response("\"[A-Za-z0-9_\\-]+\\.[A-Za-z0-9_\\-]+\\.[A-Za-z0-9_\\-]+\"", "\"REDACTED\"")
}
