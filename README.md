[![myR-CMD-check](https://github.com/MohsenSoltanifar/descfarspkg/actions/workflows/myRCMD.yml/badge.svg)](https://github.com/MohsenSoltanifar/descfarspkg/actions/workflows/myRCMD.yml)

README
================
Mohsen Soltanifar
03/08/2022

<!-- README.md is generated from README.Rmd. Please edit that file -->

# descfars

<!-- badges: start -->
<!-- badges: end -->

The goal of descfarspkg is to present a set of functions that presents
descriptive statistics and plots for FARS 2013-2015 data.

## Installation

You can install the development version of descfarspkg with:

``` r
# install.packages("devtools")
devtools::install_github("MohsenSoltanifar/descfarspkg")
```

## Example: Total monthly accidents

This function gets the year in the dataset and returns a tibble
datamatrix of two columns showing the counts of fatalities by month:
year: 2015.

``` r
library(descfarspkg)
years <- c(2015)
fars_summarize_years(years)
```
