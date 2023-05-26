
test_that("travel on public transport is faster at daytime", {
  skip_on_cran() # because API key...

  night <- gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    arr_date = as.character(Sys.Date() + 2),
    arr_time = "04:00:00", # arrival at 4 AM = bad
    mode = "transit"
  )

  day <- gmapsdistance(
    origin = "Washington DC",
    destination = "New York City NY",
    key = Sys.getenv("GOOGLE_API_KEY"),
    arr_date = as.character(Sys.Date() + 2),
    arr_time = "16:00:00", # arrival at 4 PM = good
    mode = "transit"
  )

  expect_lt(day$Time, night$Time)

})
