context("get_names")

test_that("get_names works", {
  skip_on_cran()
  
  aa <- get_names(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", options = "string")
  bb <- get_names(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", supertaxa = "immediate", 
    options = c("string namebankID"))
  cc <- get_names(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", supertaxa = "all", options = "string")
  
  expect_is(aa, "data.frame")
  expect_is(bb, "data.frame")
  expect_is(cc, "data.frame")
  
  expect_is(as.character(aa$uid), "character")
  
  expect_more_than(NROW(cc), NROW(bb))
  expect_more_than(NROW(cc), NROW(aa))
  expect_more_than(NROW(bb), NROW(aa))
})
