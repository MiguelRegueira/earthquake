#' Leaflet map of earthquakes
#'
#' This function creates a \code{leaflet} map of selected earthquakes.
#'
#' @param data A data frame containing cleaned NOAA earthquake data
#' @param annot_col A character. The name of the column in the data that should
#' be used for the pop up information. HTML code can be included in this column
#' for formatted text
#'
#' @return A leaflet map with earthquakes and annotations.
#' @export
#'
#' @importFrom leaflet leaflet addTiles addCircleMarkers
#'
#' @examples
#' \dontrun{
#' data %>% dplyr::filter(COUNTRY == "SPAIN") %>%
#'   eq_map(annot_col = "DATE")
#' }
eq_map <- function(data, annot_col) {

  map <- leaflet::leaflet() %>%
    leaflet::addTiles() %>%
    leaflet::addCircleMarkers(lng = data$LONGITUDE, lat = data$LATITUDE,
                              radius = data$EQ_PRIMARY, weight = 1,
                              popup = data[[annot_col]])

  print(map)
}


#' Creates an HTML formatted label
#'
#' This function creates an HTML formatted label that can be used
#' for the \code{leaflet} map pop up information. It includes location
#' name, magnitude and casualties from NOAA earthquake data.
#'
#' @param data A data frame containing cleaned NOAA earthquake data
#'
#' @return A character vector HTML formatted with earthquakes information
#'
#' @details The input \code{data.frame} needs to include columns LOCATION_NAME,
#' EQ_PRIMARY and TOTAL_DEATHS with the earthquake location, magintude and
#' total casualties respectively.
#'
#' @export
#'
#' @examples
#' \dontrun{
#' data %>% dplyr::filter(COUNTRY == "SPAIN") %>%
#'   dplyr::mutate(POPUP = eq_create_label(.)) %>%
#'   eq_map(annot_col = "POPUP")
#' }
eq_create_label <- function(data) {
  with(data, {
    part1 <- ifelse(is.na(LOCATION_NAME), "",
                    paste("<strong>Location:</strong>",
                          LOCATION_NAME))
    part2 <- ifelse(is.na(EQ_PRIMARY), "",
                    paste("<br><strong>Magnitude</strong>",
                          EQ_PRIMARY))
    part3 <- ifelse(is.na(TOTAL_DEATHS), "",
                    paste("<br><strong>Total deaths:</strong>",
                          TOTAL_DEATHS))
    paste0(part1, part2, part3)
  })
}
