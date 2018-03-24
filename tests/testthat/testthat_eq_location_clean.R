context("Clean location")

test_that("Clean earthquake location name", {
  raw <- readr::read_delim(system.file("extdata/signif.txt", package = "earthquake"), delim = "\t")
  clean <- eq_location_clean(raw)
  raw$LOCATION_NAME[1]
  expect_is(clean, "data.frame")
  expect_equal(raw$LOCATION_NAME[1], "JORDAN:  BAB-A-DARAA,AL-KARAK")
  expect_equal(clean$LOCATION_NAME[1], "Bab-a-Daraa,al-Karak")
  expect_equal(raw$LOCATION_NAME[1000], "JAPAN:  SANRIKU,RIKUCHU")
  expect_equal(clean$LOCATION_NAME[1000], "Sanriku,rikuchu")
  expect_error(eq_location_clean())
})
