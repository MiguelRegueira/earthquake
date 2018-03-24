globalVariables(c("MONTH", "DAY","HOUR","MINUTE", "LOCATION_NAME",
                  "EQ_PRIMARY", "LATITUDE", "LONGITUDE", "SECOND",
                  "TOTAL_DEATHS", "YEAR", "."))
#' Load and cleanup NAOO earthquakes information
#'
#' Load and cleanup NAOO earthquakes information
#'
#' @param fileName Location of file with earthquakes information
#'
#' @return A dataframe with clean information about the earthquakes
#' @export
#'
#' @examples
#' \dontrun{
#' data <- eq_clean_data()
#' }
#'
#' @importFrom magrittr %>%
eq_clean_data <- function(fileName = system.file("extdata/signif.txt", package = "earthquake")){

  data <- readr::read_delim(fileName, delim = "\t") %>%
    dplyr::mutate(MONTH = dplyr::if_else(is.na(MONTH), 1L, MONTH),
                  DAY = dplyr::if_else(is.na(DAY), 1L, DAY),
                  HOUR = dplyr::if_else(is.na(HOUR), 0L, HOUR),
                  MINUTE = dplyr::if_else(is.na(MINUTE), 0L, MINUTE),
                  SECOND = dplyr::if_else(is.na(as.numeric(SECOND)), 0.0, as.numeric(SECOND)),
                  DATE = as.POSIXct(paste0(paste(abs(YEAR), formatC(MONTH, width = 2, flag = 0), formatC(DAY, width = 2, flag = 0), sep = "-"),
                    " ",
                    paste(formatC(HOUR, width = 2, flag = 0),
                      formatC(MINUTE, width = 2, flag = 0),
                      formatC(SECOND, width = 2, flag = 0),
                      sep = ":")), tz = "GMT", format = "%Y-%m-%d %H:%M:%S"),
                  LATITUDE = as.numeric(LATITUDE),
                  LONGITUDE = as.numeric(LONGITUDE),
                  TOTAL_DEATHS = as.numeric(TOTAL_DEATHS),
                  EQ_PRIMARY = as.numeric(EQ_PRIMARY)) %>%
    eq_location_clean()

  lubridate::year(data$DATE) <- data$YEAR

  data <- dplyr::select_(data, "DATE", "COUNTRY", "LATITUDE", "LONGITUDE",
                         "LOCATION_NAME", "EQ_PRIMARY", "TOTAL_DEATHS")
}

#' Clean Location information
#'
#' Remove country and colomns from location information. Also convert names to title case
#'
#' @param data dataframe to clean-up with column LOCATION_NAME
#'
#' @return A dataframe with modified LOCATION_NAME column
#' @export
#'
#' @examples
#' \dontrun{
#' data <- readr::read_delim("./signif.txt", delim = "\t") %>%
#'   eq_location_clean()
#' }
eq_location_clean <- function(data){
  data %>% dplyr::mutate(LOCATION_NAME = strsplit(LOCATION_NAME,split = ":")) %>%
    dplyr::mutate(LOCATION_NAME = purrr::map_chr(.$LOCATION_NAME, function(x){x[length(x)]})) %>%
    dplyr::mutate(LOCATION_NAME = tools::toTitleCase(tolower(LOCATION_NAME))) %>%
    dplyr::mutate(LOCATION_NAME = trimws(LOCATION_NAME))
}
