library(testthat)
library(descfarspkg)
# Test first function make_filename

#setwd(system.file("extdata", package = "descfarspkg"))


test_that("Check number of fatalities in July 2015", {
  testthat::expect_equal(as.numeric(fars_summarize_years(c(2015))[7,2]), 2998)
})


#Run this from Console
#testthat::test_file("tests/testthat/test_functionname.R")
