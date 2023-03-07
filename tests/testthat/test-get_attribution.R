test_that("get_attribution works", {
  skip_if_offline(host = "api.phylopic.org")
  # Get valid uuid
  uuid <- get_uuid(name = "Acropora cervicornis")
  # Expect equal
  expect_true(is.list(get_attribution(uuid = uuid)))

  # Expect error
  expect_error(get_attribution(uuid = NULL))
  expect_error(get_attribution(uuid = 1))
})
