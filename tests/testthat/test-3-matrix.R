
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

test_that("pairwise works", {
  skip_on_cran() # because API key...

  # 9 element distance vector
  driving <- gmapsdistance(
    origin = c("Washington DC", "Miami FL", "Seattle WA"),
    destination = c("Miami FL", "Seattle WA", "Washington DC"),
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving",
    combinations = "pairwise"
  )

  # all cities found
  expect_true(all(driving$Status$status == "OK"))

  # status = character vector
  expect_vector(driving$Status$status)

  # pairwise = 3 results only (and not 3x3 = 9)
  expect_equal(length(driving$Status$status), 3)

})

test_that("question re web address / issue #1", {
  skip_on_cran() # because API key...

  # 2 element distance vector & pairwise
  driving <- gmapsdistance(
    origin = c("126+Wells+Ave+S+Renton+Washington+State+98057-2152",
               "6650+SW+Redwood+Ln+Ste+160+Portland+Oregon+97224-7184"),
    destination = c("West+Linn+Oregon+97068-9502",
                    "San+Mateo+California+94403-1332"),
    key = Sys.getenv("GOOGLE_API_KEY"),
    mode = "driving",
    combinations = "pairwise"
  )

  # all cities found
  expect_true(all(driving$Status$status == "OK"))

  # status = character vector
  expect_vector(driving$Status$status)

  # pairwise = 2 results for 2+2 cities
  expect_equal(length(driving$Status$status), 2)

})

test_that("one bad apple doesn't break whole pipe", {
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
  expect_equal(sum(driving$Status == "OK"), 2*2 + 1) # known points + psvz to itself
  expect_equal(sum(driving$Status == "ROUTE_NOT_FOUND"), 4)

})

