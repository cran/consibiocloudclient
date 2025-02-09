% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/client.R
\name{set_api_url}
\alias{set_api_url}
\title{Set API URL in environment variable}
\usage{
set_api_url(url = NULL)
}
\arguments{
\item{url}{A character string representing the API URL.}
}
\value{
A character string representing the API URL.
}
\description{
This function sets the API URL in the environment variable named "CONSIBIO_API_HOST".
}
\examples{
\dontrun{
set_api_url("https://api.v2.consibio.com")
}

}
