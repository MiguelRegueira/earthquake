context("Theme")

test_that('Test theme_timeline', {
  p <- eq_clean_data() %>% dplyr::filter(COUNTRY %in% c("GREECE", "ITALY")) %>%
    ggplot2::ggplot(aes(x = DATE, y = COUNTRY, color = TOTAL_DEATHS, size = EQ_PRIMARY, magnitude = EQ_PRIMARY, label = LOCATION_NAME)) +
    geom_timeline(xmin = "2000-01-01", xmax = "2010-01-01") +
    theme_timeline()

  expect_equal(p$theme$legend.position, "bottom")
  expect_equal(p$theme$axis.line.y, ggplot2::element_blank())
  expect_equal(p$theme$panel.background$fill, "white")
})
