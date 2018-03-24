#' Timeline of earthquakes
#'
#' This geom plots a timeline of earthquakes in one line with
#' options to group by country, color by number of casualties and size by scale
#'
#' @param xmin A Posixct date to filter data with date >= xmin
#' @param xmax A Posixct date to filter data with date < xmax
#'
#' @inheritParams ggplot2::geom_point
#'
#' @details The function plots a timeline of earthquakes based on cleaned NOAA
#' data. It requires \code{x} aesthetics. An optional \code{y} aesthetics can
#' be used to group data by a selected variable (for example country).
#' @export
#'
#' @importFrom ggplot2 layer
#'
#' @examples
#' \dontrun{
#' data %>% eq_clean_data() %>%
#'    dplyr::filter(COUNTRY %in% c("GREECE", "ITALY")) %>%
#'    ggplot(aes(x = DATE, y = COUNTRY, color = TOTAL_DEATHS, size = EQ_PRIMARY,
#'    magnitude = EQ_PRIMARY, label = LOCATION_NAME)) +
#'    geom_timeline(xmin = "2000-01-01", xmax = "2010-01-01") +
#'    theme_timeline()
#' }
geom_timeline <- function(mapping = NULL, data = NULL, stat = "identity",
                          position = "identity", na.rm = FALSE,
                          show.legend = NA, inherit.aes = TRUE,
                          xmin = NULL, xmax = NULL, ...) {

  ggplot2::layer(
    geom = GeomTimeline, mapping = mapping,
    data = data, stat = stat, position = position,
    show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(xmin = xmin,
                  xmax = xmax,
                  na.rm = na.rm,
                  ...)
  )
}

#' @importFrom ggplot2 aes draw_key_point
#' @importFrom grid pointsGrob linesGrob gList gpar
#' @importFrom scales alpha
GeomTimeline <- ggplot2::ggproto(
  "GeomTimeline", ggplot2::Geom,
  required_aes = c("x"),
  default_aes = ggplot2::aes(y = 0.15, colour = "grey", size = 1.5, alpha = 0.7,
                             shape = 21, fill = "grey", stroke = 0.5),
  draw_key = ggplot2::draw_key_point,

  setup_data = function(self, data, params) {
    if (!is.null(params$xmin) & IsPosixct(params$xmin)) {
      data <- dplyr::filter(data, x >= as.POSIXct(params$xmin))
    }
    else {message("Provided value in xmin cannot be converted to Posixct ", params$xmin)}
    if (!is.null(params$xmax) & IsPosixct(params$xmax)) {
      data <- dplyr::filter(data, x < as.POSIXct(params$xmax))
    }
    else {message("Provided value in xmax cannot be converted to Posixct ", params$xmax)}
    data
  },
  draw_panel = function(data, panel_scales, coord, xmin, xmax) {

    coords <- coord$transform(data, panel_scales)

    points <- grid::pointsGrob(
      coords$x, coords$y,
      pch = coords$shape, size = unit(coords$size / 4, "char"),
      gp = grid::gpar(
        col = scales::alpha(coords$colour, coords$alpha),
        fill = scales::alpha(coords$colour, coords$alpha)
      )
    )
    y_lines <- unique(coords$y)

    lines <- grid::polylineGrob(
      x = unit(rep(c(0, 1), each = length(y_lines)), "npc"),
      y = unit(c(y_lines, y_lines), "npc"),
      id = rep(seq_along(y_lines), 2),
      gp = grid::gpar(col = "light grey",
                      lwd = .pt)
    )

    grid::gList(lines, points)
  }
)


