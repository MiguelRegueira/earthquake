context("Timeline")

test_that('Test geom_timeline', {
  p <- eq_clean_data() %>% dplyr::filter(COUNTRY %in% c("GREECE", "ITALY")) %>%
    ggplot2::ggplot(aes(x = DATE, y = COUNTRY, color = TOTAL_DEATHS, size = EQ_PRIMARY, magnitude = EQ_PRIMARY, label = LOCATION_NAME)) +
    geom_timeline(xmin = "2000-01-01", xmax = "2010-01-01")

  expect_s3_class(p, 'ggplot')
  expect_length(unique(ggplot2::layer_data(p)$y), 2)
  expect_equal(sum(ggplot2::layer_data(p)$group == ggplot2::layer_data(p)$y), nrow(ggplot2::layer_data(p)))
})
