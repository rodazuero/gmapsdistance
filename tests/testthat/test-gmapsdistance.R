
# somewhere in London...
places <- data.frame(
  place = c("King's Cross St. Pancras",
            "Piccadilly Circus",
            "Null Island"),
  lat = c(51.53061, 51.50979, 0),
  long = c(-0.1239491,-0.1344288, 0)
)

test_that("modes work", {
  skip_on_cran() # because API key...

  driving <- gmapsdistance(
      origin = paste0(places$lat[1], "+", places$long[1]),
      destination = paste0(places$lat[2], "+", places$long[2]),
      key = Sys.getenv("GOOGLE_API_KEY"),
      mode = "driving"
    )

  walking <- gmapsdistance(
      origin = paste0(places$lat[1], "+", places$long[1]),
      destination = paste0(places$lat[2], "+", places$long[2]),
      key = Sys.getenv("GOOGLE_API_KEY"),
      mode = "walking"
    )

  transit <- gmapsdistance(
      origin = paste0(places$lat[1], "+", places$long[1]),
      destination = paste0(places$lat[2], "+", places$long[2]),
      key = Sys.getenv("GOOGLE_API_KEY"),
      mode = "transit"
    )

  bicycling <- gmapsdistance(
      origin = paste0(places$lat[1], "+", places$long[1]),
      destination = paste0(places$lat[2], "+", places$long[2]),
      key = Sys.getenv("GOOGLE_API_KEY"),
      mode = "bicycling"
    )

  nonsense <- gmapsdistance(
    origin = paste0(places$lat[1], "+", places$long[1]),
    destination = paste0(places$lat[3], "+", places$long[3]),
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
    origin = paste0(places$lat[1], "+", places$long[1]),
    destination = paste0(places$lat[2], "+", places$long[2])
  ))

  set.api.key(Sys.getenv("GOOGLE_API_KEY"))

  # this should work - the api key is in place
  driving <- gmapsdistance(
    origin = paste0(places$lat[1], "+", places$long[1]),
    destination = paste0(places$lat[2], "+", places$long[2])
  )

  expect_equal(driving$Status, "OK")

})

test_that("cruel & unusual encoding works", {
  skip_on_cran() # because API key...

  # this should work - the api key is in place
  driving <- gmapsdistance(
    origin = "nábřeží Kapitána Jaroše 1000/7, Prague CZ",
    destination = "вулиця Хрещатик, 14, Київ, 01001",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving"
  )

  expect_equal(driving$Status, "OK")

})


test_that("wide format works", {
  skip_on_cran() # because API key...

  # 3 x 3 distance matrix
  driving <- gmapsdistance(
    origin = c("Washington DC", "Miami FL", "Seattle WA"),
    destination = c("Washington DC", "Miami FL", "Seattle WA"),
    key = Sys.getenv("GOOGLE_API_KEY")
  )

  # all cities are found
  expect_true(all(driving$Status == "OK"))

  # status = 3x3 distance matrix
  expect_equal(dim(driving$Status), c(3, 3))

})

test_that("long format works", {
  skip_on_cran() # because API key...

  # 9 element distance vector
  driving <- gmapsdistance(
    origin = c("Washington DC", "Miami FL", "Seattle WA"),
    destination = c("Washington DC", "Miami FL", "Seattle WA"),
    key = Sys.getenv("GOOGLE_API_KEY"),
    shape = "long"
  )

  # all cities found
  expect_true(all(driving$Status$status == "OK"))

  # status = character vector
  expect_vector(driving$Status$status)

})
