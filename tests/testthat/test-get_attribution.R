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
  expect_message(get_attribution(uuid = uuid, text = TRUE))
  # Check img arg
  img <- get_phylopic(uuid = uuid[1])
  expect_true(is.list(get_attribution(img = img)))
  # Check permalink generation
  perm <- get_attribution(uuid = uuid, permalink = TRUE)
  expect_true("permalink" %in% names(perm))
  expect_message(get_attribution(uuid = uuid, text = TRUE, permalink = TRUE))

  # Expect error
  expect_error(get_attribution(uuid = NULL))
  expect_error(get_attribution(uuid = 1))
  expect_error(get_attribution(uuid = uuid, text = 1))
  expect_error(get_attribution(img = 1))
})
