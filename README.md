# Inquisit Combine Package (v.0.1.1)

This is a tiny R package to assist with combining output data from the [Millisecond Inquisit Lab](https://www.millisecond.com/products/lab) software.

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

data$sumary # This is the summary-data dataframe
data$raw # This is the raw-data dataframe
```

### Arguments

- __rootpath__ (REQUIRED, Type: [`STR`])<br>
The directory path for the folder contining all files. This can be relative or literal, and in any R-parseable path format (see below for variants).
```
path <- r"(C:\Users\Public\Documents\DATA)" # Absolute path
path <- "C:\\Users\\Public\\Documents\\DATA" # Absolute path
path <- "C:/Users/Public/Documents/DATA" # Absolute path

path <- "/DATA" # Relative path

# THIS IS THE DEFAULT WHEN COPY-PASTING FROM WINDOWS EXPLORER
# THIS WON'T WORK! SEE TOP SUGGESTION, ABOVE, INSTEAD.
# path <- "C:\Users\Public\Documents\DATA" 
```

---
- __record_filepath__ (Default: `FALSE`, Type: [`BOOLEAN`])<br>
If TRUE, this will add an additional `filepath` column to each dataframe with the entire filepath of each file. This may be useful in cases where the folder is used to identify the data. 
```
data <- inquisit.combine(path, record_filepath=TRUE)
```

---
- __filter__ (Default: `NULL`, Type: [`STR`, `LIST(STR)`])<br>
If a string or list of strings are included in this argument, the combine function will filter out any files containing this sub-string. 
Useful if needing to exclude practise data or exclude a participant by ID.
```
full_data <- inquisit.combine(path)

data_no_practise <- inquisit.combine(path, filter='practise')

excluded_pxs <- list("PX001", "PX002", "PX003") # Can also be a c() list
data_no_excluded_pxs <- inquisit.combine(path, filter=excluded_pxs)
```
