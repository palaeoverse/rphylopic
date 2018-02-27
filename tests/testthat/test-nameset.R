context("nameset_get")
test_that("nameset_get works", {
  skip_on_cran()
  
  id <- "8d9a9ea3-95cc-414d-1000-4b683ce04be2"
  aa <- nameset_get(uuid = id)

  # with options
  bb <- nameset_get(uuid = id, options=c('names','string'))
  
  expect_is(aa, "list")
  expect_is(aa$uid, "character")
  
  expect_is(bb, "list")
  expect_is(bb$names, "list")
  expect_named(bb$names[[1]], c('uid', 'string'))
})

test_that("nameset_get fails well", {
  expect_error(nameset_get(), 
    "argument \"uuid\" is missing")
})



context("nameset_taxonomy")
test_that("nameset_taxonomy works", {
  skip_on_cran()

  cc <- nameset_taxonomy(uuid = "8d9a9ea3-95cc-414d-1000-4b683ce04be2", 
    options = "string")

  expect_is(cc, "list")
  expect_is(cc$taxa, "list")
  expect_named(cc$taxa[[1]], 'canonicalName')
})

test_that("nameset_taxonomy fails well", {
  expect_error(nameset_taxonomy(), 
    "argument \"uuid\" is missing")
})

