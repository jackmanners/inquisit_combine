% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/inquisit_combine.R
\name{inquisit.combine}
\alias{inquisit.combine}
\title{Combine and Process Inquisit Data}
\usage{
inquisit.combine(
  rootpath,
  record_filepath = FALSE,
  filter = NULL,
  savepath = NULL,
  duplicates = NULL
)
}
\arguments{
\item{rootpath}{Path to the root directory of the data files.}

\item{record_filepath}{If TRUE, a column is included in the dataframe with the full file path (filename included by default).}

\item{filter}{A string or list of strings specifying filenames to be excluded from the file within rootpath (e.g., 'prac', list('px001', 'px002')). 
If NULL (default) or an empty string, no filtering is applied.}

\item{savepath}{The directory path where the combined data should be saved. If NULL, data is not saved.}

\item{duplicates}{A string indicating how duplicate entries should be handled. 
If "show", a count of duplicates is printed and a 'duplicate' column is added to each dataframe. 
If "remove", duplicate rows are eliminated from each dataframe.
If NULL (default), no action is taken for duplicate entries.}
}
\value{
A list comprising two dataframes: raw data (list$raw) and summary data (list$summary).
}
\description{
This function combines raw and summary data from Inquisit experiments.
}
\examples{
# Example usage:
result <- inquisit.combine(rootpath = "path/to/data", filter = "prac")
print(result)

}
\keyword{internal}
