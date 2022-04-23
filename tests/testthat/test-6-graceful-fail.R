test_that("API call fails gracefully", {
  skip_on_cran() # because API key...
  skip_if(is.character(RCurl::getURL("www.google.com")), "the internet is on") # othervise it would be no fun...

  expect_message( # i.e. do not expect an error!!!

  gmapsdistance(origin = "Washington DC",
                destination = "New York, NY",
                key = Sys.getenv("GOOGLE_API_KEY"))

  )

})
