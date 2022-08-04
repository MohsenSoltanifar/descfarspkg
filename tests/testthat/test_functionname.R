library(testthat)
library(descfarspkg)
# Test first function make_filename

#setwd(system.file("extdata", package = "descfarspkg"))

testthat::expect_equal(make_filename(2014),"accident_2014.csv.bz2")


#Run this from Console
#testthat::test_file("tests/testthat/test_functionname.R")
