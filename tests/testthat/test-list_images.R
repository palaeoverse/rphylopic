context("list_images")

test_that("list_images works", {
  skip_on_cran()

  aa <- list_images(start=1, length=10)
  bb <- list_images(start=1, length=10, options=c('string','taxa'))
  
  expect_is(aa, "list")
  expect_is(bb, "list")
  
  expect_is(aa[[1]], "list")
  expect_named(aa[[1]], "uid")
  expect_is(aa[[1]]$uid, "character")

  expect_is(bb[[1]], "list")
  expect_named(bb[[1]], c("taxa", "uid"))
})

test_that("list_images fails well", {
  expect_error(list_images(), 
    "argument \"start\" is missing")
  expect_error(list_images(4), 
    "argument \"length\" is missing")
})
