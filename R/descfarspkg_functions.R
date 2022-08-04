utils::globalVariables(c("year", "MONTH","STATE", "n"))
#' fars_read
#'
#' @description
#'
#' This function reads file from .csv input file.
#'
#' @source \url{http://www.nhtsa.gov/Data/Fatality-Analysis-Reporting-System-(FARS)}
#'
#' @importFrom readr read_csv
#' @importFrom  dplyr as_tibble
#'
#' @param filename A character string with the name of the file to read
#'
#' @return  This function returns a tbl_df dataframe object
#' @return An error message if the data does not exist or a data frame with data readed from the csv input file.
#'
#' @examples
#' \dontrun{fars_read("accident_2015.csv.bz2")}
#'
#' @export
fars_read <- function(filename) {
  data <- suppressMessages({
    readr::read_csv(system.file("extdata",filename, package = "descfarspkg"))
  })
  dplyr::as_tibble(data)
}



#' make_filename
#'
#' @description
#'
#' This function gets year and creates file name based on that input year.
#'
#' @param year  a numeric character representing the year.
#'
#' @return A character vector corresponding to the filenames for the  given year.
#'
#' @examples
#' \dontrun{make_filename(2015)}
#'
#' @export
make_filename <- function(year) {
  year <- as.integer(year)
  sprintf("accident_%d.csv.bz2", year)
}


#' fars_read_years
#'
#' @description
#'
#' This function reads data per input year and returns a tibble data matrix of 2 columns (Month,year).
#'
#' @importFrom dplyr mutate
#' @importFrom dplyr select
#' @importFrom   magrittr %>%
#'
#' @param years A numeric vector representing the years
#'
#' @return a tibble data-matrix of month and year and fatalities in that month
#'
#' @examples
#' \dontrun{fars_read_years(c(2014,2015))}
#'
#' @export
fars_read_years <- function(years) {
  lapply(years, function(year) {
    file <- make_filename(year)
    tryCatch({
      dat <- fars_read(file)
      dplyr::mutate(dat, year = year) %>%
        dplyr::select(MONTH,year)
    }, error = function(e) {
      warning("invalid year: ", year)
      return(NULL)
    })
  })
}



#' fars_summarize_years
#'
#' @description
#'
#' This function gets the year in the datset and returns a tibble datamatrix of two columns showing the counts of fatalities by month
#'
#' @importFrom tidyr spread
#' @importFrom magrittr %>%
#' @importFrom   rlang .data
#' @importFrom dplyr bind_rows
#' @importFrom dplyr group_by
#' @importFrom dplyr summarize
#'
#' @param years A numeric vector representing the years
#'
#' @return a tibble data-matrix of 12 by 2 (counts per month)
#'
#' @examples
#' \dontrun{fars_summarize_years(c(2014,2015))}
#'
#' @export
fars_summarize_years <- function(years) {
  dat_list <- fars_read_years(years)
  dplyr::bind_rows(dat_list) %>%
    dplyr::group_by(year,MONTH) %>%
    dplyr::summarize(n = dplyr::n()) %>%
    tidyr::spread(year, n)
}

#' fars_map_state
#'
#' @description
#'
#' This function plots the map of pointwise car fatalities in given year at a given American state.
#'
#' @importFrom dplyr filter
#' @importFrom maps map
#' @importFrom graphics points
#'
#' @param state.num A numeric vector representing the number of the American state: 1-51
#' @param year A numeric vector representing the years: 2013-2015
#'
#' @return a map of American state and points of fatalities
#'
#' @examples
#' \dontrun{fars_map_state(10,2015)}
#'
#' @export
fars_map_state <- function(state.num, year) {
  filename <- make_filename(year)
  data <- fars_read(filename)
  state.num <- as.integer(state.num)

  if(!(state.num %in% unique(data$STATE)))
    stop("invalid STATE number: ", state.num)
  data.sub <- dplyr::filter(data, STATE == state.num)
  if(nrow(data.sub) == 0L) {
    message("no accidents to plot")
    return(invisible(NULL))
  }
  is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
  is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
  with(data.sub, {
    maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
              xlim = range(LONGITUD, na.rm = TRUE))
    graphics::points(LONGITUD, LATITUDE, pch = 46)
  })
}
