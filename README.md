# Inquisit Combine Package

This is a tiny R package to assist with combining output data from the (https://www.millisecond.com/products/lab)[Millisecond Inquisit Lab] software.

## Installation

This package is built on R-4.2.1. I have not tested it on other versions, but in its current state it should be compatible with any R version that is compatible with dependencies.

This package is not on CRAN. As such, you will need the devtools package to install via the GitHub repository. Complete installation can be done via the following commands.
```
install.packages('devtools')
library(devtools)
install_github('jackmanners/inquisit_combine')
```

## Usage

The package currently has one function (`inquisit.combine`) which accepts a directory path and optional filter string. This will then (recursively) find all inquisit output files (`*.iqdat`) in the directory, sort them into summary and raw files, (optionally) filter out unwanted files, and then combine them into a list of two dataframes. 

See below for basic usage.
```
library(inquisit.combine)

path <- r"(C:\Users\Public\Documents\DATA)"
data <- inquisit.combine(path)

data$df_sum # This is the summary-data dataframe
data$df_raw # This is the raw-data dataframe
```

## Additional Details

Currently this package adds the filename as a column in the dataframe to assist with identification. Plans are to add an option to add the entire relative filepath (e.g., if it's in the subfolder 'PARTICIPANT001', the 'file' variable will be 'PARTICIPANT001/FILENAME.iqdat', rather than just 'FILENAME.iqdat'). This will be a boolean `record_folders` argument, should be added soon. 