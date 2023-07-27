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
  
  # Read and combine raw data files
  df_raw <- rbindlist(lapply(all_files_raw, function(f) {
    fread(f, sep = "\t")[, file := basename(f)]
  }))
  
  # Read and combine summary data files
  df_sum <- rbindlist(lapply(all_files_sum, function(f) {
    fread(f, sep = "\t")[, file := basename(f)]
  }))

  # Filter from file names and convert to uppercase if filter is provided
  if (!is.null(filter) && nchar(filter) > 0) {
    df_raw$file <- toupper(df_raw$file)
    df_raw <- df_raw[!str_detect(df_raw$file, filter)]
    df_sum$file <- toupper(df_sum$file)
    df_sum <- df_sum[!str_detect(df_sum$file, filter)]
  }
  
  return(list(df_sum = df_sum, df_raw = df_raw))
}

