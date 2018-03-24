#' Theme for eq_timeline figures
#'
#' Convert figure theme to a white background, without Y axis and legend at the bottom figure
#'
#' @return Nothing
#' @export
#'
#' @param base_size Default \code{11}, base size of text
#' @param base_family Default \code{sans}, text family
#'
#' @importFrom ggplot2 %+replace%
#'
#' @examples
#' \dontrun{
#' library(dplyr); library(ggplot2)
#' data %>% eq_clean_data() %>%
#'    dplyr::filter(data, COUNTRY %in% c("GREECE", "ITALY")) %>%
#'    ggplot(aes(x = DATE, y = COUNTRY, color = TOTAL_DEATHS, size = EQ_PRIMARY, magnitude = EQ_PRIMARY, label = LOCATION_NAME)) +
#'    geom_timeline(xmin = "2000-01-01", xmax = "2010-01-01") +
#'    theme_timeline()
#' }
theme_timeline <- function (base_size = 11, base_family = ""){
  ggplot2::theme_classic(base_size = base_size, base_family = base_family) %+replace%
    ggplot2::theme(panel.background = ggplot2::element_rect(fill = "white", colour = NA),
                   legend.key = ggplot2::element_rect(fill = "white", colour = NA),
                   axis.title.y = ggplot2::element_blank(),
                   axis.line.y = ggplot2::element_blank(),
                   legend.position = "bottom",
                   axis.ticks.y = ggplot2::element_blank(),
                   complete = TRUE)
}
