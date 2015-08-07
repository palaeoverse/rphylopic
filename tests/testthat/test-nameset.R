context("nameset")

test_that("nameset_get works", {
  skip_on_cran()
  
  id <- "8d9a9ea3-95cc-414d-1000-4b683ce04be2"
  aa <- nameset_get(uuid = id)
  bb <- nameset_get(uuid = id, options=c('names','string'))
  
  expect_is(aa, "list")
  expect_is(aa$uid, "character")
  
  expect_is(bb, "list")
  expect_is(bb$names, "list")
  expect_named(bb$names[[1]], c('uid', 'string'))
})


test_that("nameset_taxonomy works", {
  skip_on_cran()

  cc <- nameset_taxonomy(uuid = "8d9a9ea3-95cc-414d-1000-4b683ce04be2", options = "string")
  dd <- nameset_taxonomy(uuid = "8d9a9ea3-95cc-414d-1000-4b683ce04be2", supertaxa="immediate",
                         options=c("string","namebankID"))

  expect_is(cc, "list")
  expect_is(cc$taxa, "list")
  expect_named(cc$taxa[[1]], 'canonicalName')
  
  expect_is(dd, "list")
  expect_is(dd$taxa, "list")
  expect_named(dd$taxa[[1]]$canonicalName, c('uid', 'namebankID', 'string'))
})
