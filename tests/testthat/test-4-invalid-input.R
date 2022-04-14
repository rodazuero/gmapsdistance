

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

  # API Key
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = "bflm",
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
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "transit"
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

  # departure date without time
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    dep_date = as.character(Sys.Date() + 3),
    key = Sys.getenv("GOOGLE_API_KEY")
  ))

  # departure time without date
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    dep_time = "12:00:00",
    key = Sys.getenv("GOOGLE_API_KEY")
  ))

  # arrival date without time
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    arr_date = as.character(Sys.Date() + 3),
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "transit"
  ))

  # arrival time without date
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    arr_time = "12:00:00",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "transit"
  ))

  # incompatible lengths in pairwise
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = c("New York City NY", "Miami FL"),
    key = Sys.getenv("GOOGLE_API_KEY"),
    combinations = "pairwise"
  ))

})

test_that("past is past...", {
  skip_on_cran() # because API key...

  # departure in the past
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    dep_date = as.character(Sys.Date() - 3),
    dep_time = "12:00:00",
    key = Sys.getenv("GOOGLE_API_KEY")
  ))

  # arrival in the past
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    arr_date = as.character(Sys.Date() - 3),
    arr_time = "12:00:00",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "transit"
  ))

})

test_that("multiple times", {
  skip_on_cran() # because API key...

  # departure twice - date
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    dep_date = c(as.character(Sys.Date() + 3),
                 as.character(Sys.Date() + 4)),
    dep_time = "12:00:00",
    key = Sys.getenv("GOOGLE_API_KEY")
  ))


  # departure twice - time
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    dep_date = as.character(Sys.Date() + 3),
    dep_time = c("12:00:00", "13:00:00"),
    key = Sys.getenv("GOOGLE_API_KEY")
  ))

  # arrival twice - date
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    arr_date = c(as.character(Sys.Date() - 3),
                 as.character(Sys.Date() - 4)),
    arr_time = "12:00:00",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "transit"
  ))

  # arrival twice - time
  expect_error(gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    arr_date = as.character(Sys.Date() - 3),
    arr_time = c("12:00:00",
                 "13:00:00"),
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "transit"
  ))

})
