test_that("modes work", {
  skip_on_cran() # because API key...

  driving <- gmapsdistance(
      origin = "King's Cross St. Pancras",
      destination = "Piccadilly Circus",
      key = Sys.getenv("GOOGLE_API_KEY"),
      mode = "driving"
    )

  walking <- gmapsdistance(
      origin = "King's Cross St. Pancras",
      destination = "Piccadilly Circus",
      key = Sys.getenv("GOOGLE_API_KEY"),
      mode = "walking"
    )

  transit <- gmapsdistance(
      origin = "King's Cross St. Pancras",
      destination = "Piccadilly Circus",
      key = Sys.getenv("GOOGLE_API_KEY"),
      mode = "transit"
    )

  bicycling <- gmapsdistance(
      origin = "King's Cross St. Pancras",
      destination = "Piccadilly Circus",
      key = Sys.getenv("GOOGLE_API_KEY"),
      mode = "bicycling"
    )

  nonsense <- gmapsdistance(
    origin = "King's Cross St. Pancras",
    destination = "0,0",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving"
  )

  # http status - all modes should return a value
  expect_equal(driving$Status, "OK")
  expect_equal(walking$Status, "OK")
  expect_equal(transit$Status, "OK")
  expect_equal(bicycling$Status, "OK")

  # there is no route known from London to the Null Island
  expect_equal(nonsense$Status, "ROUTE_NOT_FOUND")

  # sanity check
  expect_gt(walking$Time, driving$Time) # walking is slower than driving ...
  expect_lt(walking$Distance, driving$Distance) # ... but takes a more direct path

  expect_gt(bicycling$Time, transit$Time) # Tube is faster than both bike...
  expect_gt(driving$Time, transit$Time) # ... and driving (in London)

})


test_that("environment variable works", {
  skip_on_cran() # because API key...

  # this should break - no api key is set (yet)
  expect_error(driving <- gmapsdistance(
    origin = "King's Cross St. Pancras",
    destination = "Piccadilly Circus",
  ))

  set.api.key(Sys.getenv("GOOGLE_API_KEY"))

  # this should work - the api key is in place
  driving <- gmapsdistance(
    origin = "King's Cross St. Pancras",
    destination = "Piccadilly Circus",
  )

  expect_equal(driving$Status, "OK")

})
