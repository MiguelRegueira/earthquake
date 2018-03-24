#' Timeline labels of earthquakes
#'
#' This geom plots timeline labels of earthquakes. It assumes that
#' \code{geom_timeline} was used to create the timelines
#'
#' @param n_max An integer. If used, it only plots the labels for the
#' \code{n_max} largest earthquakes in the selected group in the timeline
#' @param angle Anglo to represent label text, default 45º
#' @param xmin A Posixct date to filter data with date >= xmin
#' @param xmax A Posixct date to filter data with date < xmax
#'
#' @inheritParams ggplot2::geom_point
#'
#'
#' @details The function plots timeline labels of earthquakes based on cleaned
#' NOAA data. It should be used with combination with \code{geom_timeline}. The
#' required aesthetics for this geom is \code{label} that should contain
#' string for labeling each data point.
#' @export
#'
#' @importFrom ggplot2 layer
#'
#' @examples
#' \dontrun{
#' data %>% eq_clean_data() %>%
#'    dplyr::filter(COUNTRY %in% c("GREECE", "ITALY")) %>%
#'    ggplot(aes(x = DATE, y = COUNTRY, color = TOTAL_DEATHS, size = EQ_PRIMARY, magnitude = EQ_PRIMARY, label = LOCATION_NAME)) +
#'    geom_timeline_label(xmin = "2000-01-01", xmax = "2010-01-01", n_max = 2, angle = 60) +
#'    geom_timeline(xmin = "2000-01-01", xmax = "2010-01-01") +
#'    theme_timeline()
#' }
geom_timeline_label <- function(mapping = NULL, data = NULL, stat = "identity",
                          position = "identity", na.rm = FALSE,
                          show.legend = NA, inherit.aes = TRUE,
                          xmin = NULL, xmax = NULL,
                          n_max = NULL, angle = 45, ...) {

  ggplot2::layer(
    geom = GeomTimelineLabel, mapping = mapping,
    data = data, stat = stat, position = position,
    show.legend = show.legend, inherit.aes = inherit.aes,
    params = list(xmin = xmin,
                  xmax = xmax,
                  n_max = n_max,
                  na.rm = na.rm,
                  angle = angle,
                  ...)
  )
}

#' @importFrom ggplot2 aes draw_key_point
#' @importFrom grid pointsGrob linesGrob gList gpar
#' @importFrom scales alpha
GeomTimelineLabel <- ggplot2::ggproto(
  "GeomTimelineLabel", ggplot2::Geom,
  required_aes = c("x", "label", "magnitude"),
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

    if (!is.null(params$n_max) & !is.na(as.numeric(params$n_max))) {
      data <- dplyr::group_by(data, y) %>%
        dplyr::top_n(as.numeric(params$n_max), magnitude)
    }
    else{message("Provided value in n_max shall be numeric ", params$n_max)}

    data
  },
  draw_panel = function(data, panel_scales, coord, xmin, xmax, n_max, angle) {

    coords <- coord$transform(data, panel_scales)

    y_lines <- unique(coords$y)
    offset = 0.2 / length(y_lines)

    lines <- grid::polylineGrob(
      x = unit(c(coords$x, coords$x), "npc"),
      y = unit(c(coords$y, coords$y + offset), "npc"),
      id = rep(1:dim(coords)[1], 2),
      gp = grid::gpar(col = "light grey",
                      lwd = .pt)
    )

    names <- grid::textGrob(
      label = coords$label,
      x = unit(coords$x, "npc"),
      y = unit(coords$y + offset, "npc"),
      just = c("left", "bottom"),
      rot = angle,
      gp = grid::gpar(col = "grey34",
                      lwd = .pt)
    )

    grid::gList(lines, names)
  }
)
