test_that("pesky troublemaker", {
  skip_on_cran() # because API key...

  results <- gmapsdistance(origin = c("Washington DC", "New York NY"),
                           destination = c("Los Angeles CA", "Austin TX"),
                           mode = "driving",
                           dep_date = as.character(Sys.Date() + 122),  # to make reproducible...
                           dep_time = "20:40:00",
                           traffic_model = "pessimistic",
                           shape = "long",
                           key = Sys.getenv("GOOGLE_API_KEY"))

  expect_equal(unique(results$Status$status), "OK")
  expect_equal(any(is.na(results$Time$Time)), FALSE)


  gmapsdistance(origin = c("Washington DC", "New York NY",
                           "Seattle WA", "Miami FL"),
                destination = c("Los Angeles CA", "Austin TX",
                                "Chicago IL", "Philadelphia PA"),
                mode = "bicycling",
                # departure time as seconds from Unix Epoch (1970-01-01)
                departure = 1660682400,
                key = Sys.getenv("GOOGLE_API_KEY"))

  expect_equal(unique(results$Status$status), "OK")
  expect_equal(any(is.na(results$Time$Time)), FALSE)

})
