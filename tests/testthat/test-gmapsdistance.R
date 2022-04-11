
# somewhere in London...
places <- data.frame(place = c("King's Cross St. Pancras",
                               "Piccadilly Circus"),
                     lat = c(51.53061, 51.50979),
                     long = c(-0.1239491, -0.1344288))

test_that("modes work", {

  skip_on_cran() # because API key...

  driving <- gmapsdistance(origin = paste0(places$lat[1], "+", places$long[1]),
                        destination = paste0(places$lat[2], "+", places$long[2]),
                        key = Sys.getenv("GOOGLE_API_KEY"),
                        mode = "driving")

  walking <- gmapsdistance(origin = paste0(places$lat[1], "+", places$long[1]),
                           destination = paste0(places$lat[2], "+", places$long[2]),
                           key = Sys.getenv("GOOGLE_API_KEY"),

              mode = "walking")
  transit <- gmapsdistance(origin = paste0(places$lat[1], "+", places$long[1]),
                           destination = paste0(places$lat[2], "+", places$long[2]),
                           key = Sys.getenv("GOOGLE_API_KEY"),
                           mode = "transit")

  bicycling <- gmapsdistance(origin = paste0(places$lat[1], "+", places$long[1]),
                           destination = paste0(places$lat[2], "+", places$long[2]),
                           key = Sys.getenv("GOOGLE_API_KEY"),
                           mode = "bicycling")

  # http status - all modes should return a value
  expect_equal(driving$Status, "OK")
  expect_equal(walking$Status, "OK")
  expect_equal(transit$Status, "OK")
  expect_equal(bicycling$Status, "OK")

  # sanity check
  expect_gt(walking$Time, driving$Time) # walking is slower than driving ...
  expect_lt(walking$Distance, driving$Distance) # ... but takes a more direct path

  expect_gt(bicycling$Time, transit$Time) # Tube is faster than both bike...
  expect_gt(driving$Time, transit$Time) # ... and driving (in London)

})
