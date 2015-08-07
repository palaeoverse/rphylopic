context("list_images")

test_that("returns the correct class", {
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
