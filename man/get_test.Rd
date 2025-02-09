% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/api-get_test.R
\name{get_test}
\alias{get_test}
\title{Consibio APIs status by calling the test endpoint}
\usage{
get_test()
}
\value{
A list with the status of the API and the time of the request.
}
\description{
Get the status of requests directly at Consibio APIs. Does not require authentication.
}
\details{
See details in https://api.v2.consibio.com/api-docs/#/default/get_test
}
\examples{
\dontrun{
c_get_test()
}
}
