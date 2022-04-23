
test_that("cruel & unusual encoding works", {
  skip_on_cran() # because API key...

  driving <- gmapsdistance(
    origin = "nábřeží Kapitána Jaroše 1000/7, Prague CZ",
    destination = "вулиця Хрещатик, Київ",
    key = Sys.getenv("GOOGLE_API_KEY")
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
    mode = "transit"
  )

  expect_equal(driving$Status, "OK")

})

test_that("traffic works", {
  skip_on_cran() # because API key...

  # departure:
  pessimistic <- gmapsdistance(
    origin = "King's Cross St. Pancras",
    destination = "Piccadilly Circus",
    dep_date = as.character(Sys.Date() + 3),
    dep_time = "8:00:00",
    traffic_model = "pessimistic",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving"
  )

  optimistic <- gmapsdistance(
    origin = "King's Cross St. Pancras",
    destination = "Piccadilly Circus",
    dep_date = as.character(Sys.Date() + 3),
    dep_time = "8:00:00",
    traffic_model = "optimistic",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving"
  )

  # bad traffic = longer time...
  expect_gte(pessimistic$Time, optimistic$Time)
  # gt would be better in principle, but in practice API _can_
  # return equal times for good & bad traffic (should not, but does...)

})

test_that("multiple avoid arguments work", {
  skip_on_cran() # because API key...

  driving <- gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    avoid = c("ferries", "tolls")
  )

  expect_equal(driving$Status, "OK")

  # avoid ferries (no big deal)
  ferries <- gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    avoid = "ferries"
  )

  # avoid tolls = big impact
  tolls <- gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    avoid = "tolls"
  )

  # no tolls = longer time...
  expect_gt(tolls$Time, ferries$Time)

})

test_that("duration_key works", {
  skip_on_cran() # because API key...

  # request time in traffic - should produce time in traffic (i.e. not plain time)
  driving <- gmapsdistance(
    origin = "King's Cross St. Pancras",
    destination = "Piccadilly Circus",
    dep_date = as.character(Sys.Date() + 1),
    dep_time = "8:00:00",
    traffic_model = "best_guess",
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving"
  )

  expect_equal(driving$Status, "OK")

})
