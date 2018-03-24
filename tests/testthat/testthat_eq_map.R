context("Map")

test_that('Map is created', {
  data <- eq_clean_data() %>%
    dplyr::filter(COUNTRY == "SPAIN")

  m <- eq_map(data, annot_col = 'DATE')

  expect_s3_class(m, 'leaflet')
  expect_s3_class(m, 'htmlwidget')
})
