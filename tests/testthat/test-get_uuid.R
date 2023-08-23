test_that("get_uuid works", {
  skip_if_offline(host = "api.phylopic.org")
  # Expect true
  expect_true(is.character(get_uuid(name = "Acropora cervicornis")))
  expect_true(is.character(get_uuid(name = "Tyrannosaurus", url = TRUE)))
  expect_true(is.character(get_uuid(name = "Acropora", n = 1, url = TRUE)))
  expect_true(length(get_uuid(name = NULL, n = 100)) == 100)
  expect_true(length(get_uuid(name = NULL, n = 100, url = TRUE)) == 100)
  uuid <- get_uuid(name = "Scleractinia")
  img <- get_phylopic(uuid = uuid)
  expect_equal(length(get_uuid(img = img)), 1)
  expect_equal(length(get_uuid(img = img, url = TRUE)), 1)
  # Expect warnings
  expect_warning(is.character(get_uuid(name = "Acropora", n = 50, url = TRUE)))
  # Expect errors
  expect_error(get_uuid(name = 1))
  expect_error(get_uuid(name = "Acropora cervicornis", url = 1))
  expect_error(get_uuid(name = "Acropora cervicornis", n = "5"))
  expect_error(get_uuid(img = "5d646d5a-b2dd-49cd-b450-4132827ef25e"))
})
