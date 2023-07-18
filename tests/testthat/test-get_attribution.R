test_that("get_attribution works", {
  skip_if_offline(host = "api.phylopic.org")
  # Get valid uuid
  uuid <- get_uuid(name = "Acropora cervicornis")
  # Expect true
  expect_true(is.list(get_attribution(uuid = uuid)))
  expect_true(is.null(get_attribution(uuid = uuid, text = TRUE)))
  # Expect equal
  uuid <- get_uuid(name = "Scleractinia", n = 5)
  expect_equal(length(get_attribution(uuid = uuid)), 5)

  # Expect error
  expect_error(get_attribution(uuid = NULL))
  expect_error(get_attribution(uuid = 1))
  expect_error(get_attribution(uuid = uuid, text = 1))
})
