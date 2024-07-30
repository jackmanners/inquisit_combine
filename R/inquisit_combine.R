#' Combine and Process Inquisit Data
#'
#' This function combines raw and summary data from Inquisit experiments.
#' 
#' @param rootpath Path to the root directory of the data files.
#' @param record_filepath If TRUE, a column is included in the dataframe with the full file path (filename included by default).
#' @param filter A string or list of strings specifying filenames to be excluded from the file within rootpath (e.g., 'prac', list('px001', 'px002')). 
#'               If NULL (default) or an empty string, no filtering is applied.
#' @param savepath The directory path where the combined data should be saved. If NULL, data is not saved.
#' @param duplicates A string indicating how duplicate entries should be handled. 
#' If "show", a count of duplicates is printed and a 'duplicate' column is added to each dataframe. 
#' If "remove", duplicate rows are eliminated from each dataframe.
#' If NULL (default), no action is taken for duplicate entries.
#' @return A list comprising two dataframes: raw data (list$raw) and summary data (list$summary).
#' @export
#' 
#' @examples
#' # Example usage:
#' result <- inquisit.combine(rootpath = "path/to/data", filter = "prac")
#' print(result)
#'
#' @import dplyr
#' @import stringr
#' @import data.table
#' @import pbapply
#'
#' @keywords internal

inquisit.combine <- function(rootpath, record_filepath=FALSE, filter = NULL, savepath=NULL, duplicates=NULL) {
  avg_time_per_file_sec <- 0.05

  ### VALIDATION ###

  # Check if single path provided as character string and if so, convert to list for consistent processing
  if (is.null(rootpath)) {
    stop("At least one rootpath must be provided.")
  }
  if (is.character(rootpaths)) {
    rootpaths <- list(rootpaths)
  }
  
  # Validate the filter parameter
  if (!is.null(filter) && !is.character(filter) && !is.list(filter)) {
    stop("Filter parameter must be a string or a list of strings.")
  }

  # Validate the duplicates parameter
  if (!is.null(duplicates) && !(duplicates %in% c("show", "remove"))) {
    stop("Duplicates parameter must be NULL, 'show', or 'remove'.")
  }

  # Checking if rootpaths & savepath exists and is a directory
  lapply(rootpaths, function(path) {
    if (!file.exists(path) || !file.info(path)$isdir) {
      stop(paste("The provided root path", path, "does not exist or is not a directory."))
    }
  })

  if (!is.null(savepath) && (!file.exists(savepath) || !file.info(savepath)$isdir)) {
    stop("The provided save path does not exist or is not a directory.")
  }
  
  # Convert single string filters to a list for consistent processing
  if (is.character(filter)) {
    filter <- list(filter)
  }

  ######
  
  ### File Collecting and Combining ###

  all_files_raw <- c()
  all_files_sum <- c()

  for (rootpath in rootpaths) {
    # Get file paths for all raw and summary files
    all_files_raw <- c(all_files_raw, list.files(path = rootpath, pattern = "raw", full.names = TRUE))
    all_files_sum <- c(all_files_sum, list.files(path = rootpath, pattern = "summary", full.names = TRUE))
  }

  # Estimated time
  estimated_time_raw_sec <- length(all_files_raw) * avg_time_per_file_sec
  estimated_time_sum_sec <- length(all_files_sum) * avg_time_per_file_sec
  total_estimated_time_sec <- estimated_time_raw_sec + estimated_time_sum_sec
  total_estimated_time_min <- total_estimated_time_sec / 60
  cat("Files found:", length(all_files_raw), "raw files,", length(all_files_sum), "summary files\n")  
  cat("Estimated time to process all files: ", round(total_estimated_time_min, 2), "minutes (", 
      round(total_estimated_time_sec, 0), "seconds)\n")
  
  # Progress indicator setup
  progress_fn_raw <- function(n) cat("\rProcessing raw file ", n, " of ", length(all_files_raw))
  progress_fn_summary <- function(n) cat("\rProcessing summary file ", n, " of ", length(all_files_sum))

  # File process function
  process_file <- function(f, files) {
    cat("\rProcessing file ", which(files == f), " of ", length(files))
    data <- fread(f, sep = "\t")
    if (record_filepath) data[, file_path := f]
    data[, file := basename(f)]
  }

  raw <- rbindlist(pbapply::pblapply(all_files_raw, process_file, all_files_raw))
  summary <- rbindlist(pbapply::pblapply(all_files_sum, process_file, all_files_sum))
  ######

  ### Filtering ###
  # Filter from file names and convert to uppercase if filters are provided
  filter_file <- function(data, filt) {
    data <- data[!str_detect(toupper(data$file), toupper(filt))]
  }

  if (!is.null(filter)) {
    for (filt in filter) {
      if (nchar(filt) > 0) {
        raw <- filter_file(raw, filt)
        summary <- filter_file(summary, filt)
      }
    }
  }
  ######
  
  ### Duplicates ###
  detect_duplicates <- function(data) {
    data %>% 
      group_by(across(everything())) %>% 
      mutate(duplicate = row_number() > 1) %>% 
      ungroup()
  }

  if (!is.null(duplicates)) {
    raw <- detect_duplicates(raw)
    summary <- detect_duplicates(summary)

    if (duplicates == "show") {
      cat("Number of duplicate rows in raw data:", sum(raw$duplicate), "\n")
      cat("Number of duplicate rows in summary data:", sum(summary$duplicate), "\n")
    } else if (duplicates == "remove") {
      raw <- raw %>% filter(!duplicate)
      summary <- summary %>% filter(!duplicate)
    }
  }
  ######

  result <- list(summary = summary, raw = raw)
  
  # Save combined data if savepath is provided
  if (!is.null(savepath)) {
    write.csv(result$summary, file.path(savepath, "data_summary.csv"))
    write.csv(result$raw, file.path(savepath, "data_raw.csv"))
  }
  
  cat("\nData combination completed.\n")
  
  return(result)
}
