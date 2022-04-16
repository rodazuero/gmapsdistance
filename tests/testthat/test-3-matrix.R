
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

  # default combinations = all / i.e. 3x3 = 9
  expect_gt(length(driving$Status$status), 3)

})

test_that("pairvise works", {
  skip_on_cran() # because API key...

  # 9 element distance vector
  driving <- gmapsdistance(
    origin = c("Washington DC", "Miami FL", "Seattle WA"),
    destination = c("Washington DC", "Miami FL", "Seattle WA"),
    key = Sys.getenv("GOOGLE_API_KEY"),
    shape = "long",
    combinations = "pairwise"
  )

  # all cities found
  expect_true(all(driving$Status$status == "OK"))

  # status = character vector
  expect_vector(driving$Status$status)

  # pairwise = 3 results only (and not 3x3 = 9)
  expect_equal(length(driving$Status$status), 3)

})

test_that("one bad apple doesn' break whole pipe", {
  skip_on_cran() # because API key...

  # 3 x 3 distance matrix
  driving <- gmapsdistance(
    origin = c("Washington DC", "psvz", "Seattle WA"),
    destination = c("Washington DC", "psvz", "Seattle WA"),
    key = Sys.getenv("GOOGLE_API_KEY")
  )

  # status = 3x3 distance matrix
  expect_equal(dim(driving$Status), c(3, 3))

  # 2 found, 3 identity, 4 no idea
  expect_equal(sum(driving$Status == "OK"), 2+3)
  expect_equal(sum(driving$Status == "ROUTE_NOT_FOUND"), 4)

})

