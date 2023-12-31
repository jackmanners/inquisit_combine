% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inquisit_combine.R
\name{inquisit.combine}
\alias{inquisit.combine}
\title{Inquisit Combine Function}
\usage{
inquisit.combine(rootpath, filter)
}
\arguments{
\item{rootpath}{The root path of the data folders.}

\item{filter}{A string to be filtered from files within rootpath (e.g., 'prac').
If NULL or an empty string, no filtering will be applied.}
}
\value{
A list containing raw and summary data frames.
}
\description{
Combines raw and summary data from Inquisit experiments.
}
\examples{
# Example usage:
result <- inquisit.combine(rootpath = "path/to/data", filter = "prac")
result

}
\keyword{internal}
