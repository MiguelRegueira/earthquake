context("Read data")

test_that("Read earthquakes data", {
  data <- eq_clean_data()
  expect_is(data, "data.frame")
  expect_equal(nrow(data), 6001)
  expect_equal(ncol(data), 7)
  expect_equal(data[[1,6]], 7.30)
  expect_equal(data[[6001,7]], 30.0)
  expect_error(eq_clean_data("non.existing.file"))
})
