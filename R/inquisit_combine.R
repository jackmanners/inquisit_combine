#' Inquisit Combine Function
#'
#' Combines raw and summary data from Inquisit experiments.
#' 
#' @param rootpath The root path of the data folders.
#' @param filter A string to be filtered from files within rootpath (e.g., 'prac').
#'               If NULL or an empty string, no filtering will be applied.
#' @return A list containing raw and summary data frames.
#' @export
#' 
#' @examples
#' # Example usage:
#' result <- inquisit.combine(rootpath = "path/to/data", filter = "prac")
#' result
#'
#' @import dplyr
#' @import stringr
#' @import data.table
#' @import pbapply
#'
#' @keywords internal

inquisit.combine <- function(rootpath, filter = NULL) {
  # Validate the filter parameter
  if (!is.null(filter) && !is.character(filter)) {
    stop("Filter parameter must be a string.")
  }
  
  # Get file paths for all raw and summary files
  all_files_raw <- list.files(path = rootpath, pattern = "raw", full.names = TRUE)
  all_files_sum <- list.files(path = rootpath, pattern = "summary", full.names = TRUE)
  
  # Print the files to be combined
  num_raw_files <- length(all_files_raw)
  num_summary_files <- length(all_files_sum)
  cat("Files found:", num_raw_files, "raw files,", num_summary_files, "summary files\n")
  
  # Progress indicator setup
  progress_fn_raw <- function(n) cat("\rProcessing raw file ", n, " of ", length(all_files_raw))
  progress_fn_summary <- function(n) cat("\rProcessing summary file ", n, " of ", length(all_files_sum))

  # Read and combine raw data files
  raw <- rbindlist(pbapply::pblapply(all_files_raw, function(f) {
    progress_fn_raw(which(all_files_raw == f))
    fread(f, sep = "\t")[, file := basename(f)]
  }))
  
  
  # Read and combine summary data files
  summary <- rbindlist(pbapply::pblapply(all_files_sum, function(f) {
    progress_fn_summary(which(all_files_sum == f))
    fread(f, sep = "\t")[, file := basename(f)]
  }))

  # Filter from file names and convert to uppercase if filter is provided
  if (!is.null(filter) && nchar(filter) > 0) {
    raw$file <- toupper(raw$file)
    raw <- raw[!str_detect(raw$file, filter)]
    summary$file <- toupper(summary$file)
    summary <- summary[!str_detect(summary$file, filter)]
  }
  
  cat("\nData combination completed.\n")
  return(list(summary = summary, raw = raw))
}