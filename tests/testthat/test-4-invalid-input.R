

test_that("missing mandatory inputs", {
  skip_on_cran() # because API key...

  # missing origin
  expect_error(gmapsdistance(
    destination = "New York City NY",
    key = Sys.gegtenv("GOOGLE_API_KEY"),
    mode = "driving"
  ))

  # missin destination
  expect_error(gmapsdistance(
    origin = "Washington DC",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving"
  ))

  # not specified departure
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    arr_date = as.character(Sys.Date() + 3),
    arr_time = "12:00:00",
    traffic_model = "pessimistic",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving"
  ))


})

test_that("misspelled input", {
  skip_on_cran() # because API key...

  # mode
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "bflm"
  ))

  # combination
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    combinations = "bflm"
  ))

  # avoid
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    avoid = "bflm"
  ))

  # departure
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    departure = "bflm"
  ))

  # model
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    departure = "now", # or model would be illegal
    traffic_model = "bflm"
  ))


})

test_that("illegal combinations", {
  skip_on_cran() # because API key...

  # illegal departure + arrival combination / either is fine, both is wrong
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    dep_date = as.character(Sys.Date() + 3),
    dep_time = "12:00:00",
    arr_date = as.character(Sys.Date() + 3),
    arr_time = "12:00:00",
    key = Sys.getenv("GOOGLE_API_KEY")
  ))

  # illegal model + mode combination
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    dep_date = as.character(Sys.Date() + 3),
    dep_time = "12:00:00",
    traffic_model = "pessimistic",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "walking"
  ))

  # multiple modes of transport
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = c("walking", "driving")
  ))

  # multiple combinations
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    combinations = c("all", "pairwise")
  ))


  # illegal arrival & mode
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    arr_date = as.character(Sys.Date() + 3),
    arr_time = "12:00:00",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving"
  ))

})
