
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

test_that("start date works", {
  skip_on_cran() # because API key...

  driving <- gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    dep_date = as.character(Sys.Date() + 3),
    dep_time = "12:00:00",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving"
  )

  expect_equal(driving$Status, "OK")

})

test_that("arrrival date works", {
  skip_on_cran() # because API key...

  driving <- gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    arr_date = as.character(Sys.Date() + 3),
    arr_time = "12:00:00",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving"
  )

  expect_equal(driving$Status, "OK")

})
