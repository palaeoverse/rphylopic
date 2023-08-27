test_that("browse_phylopic works", {
  skip_if_offline(host = "api.phylopic.org")
  uuid <- "f6a243aa-5cb1-41a2-a52c-c8d4c4300104"
  # Expect true
  expect_true(is.character(browse_phylopic()))
  expect_true(is.character(browse_phylopic(name = "Acropora cervicornis")))
  expect_true(is.character(browse_phylopic(uuid = uuid)))
  # Expect errors
  expect_error(browse_phylopic(name = 1))
  expect_error(browse_phylopic(uuid = 1))
  expect_error(browse_phylopic(name = "Acropora cervicornis", uuid = uuid))
})
