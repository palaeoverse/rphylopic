test_that("get_uuid works", {
  skip_if_offline(host = "api.phylopic.org")
  # Expect true
  expect_true(is.character(get_uuid(name = "Acropora cervicornis")))
  expect_true(is.character(get_uuid(name = "Tyrannosaurus", url = TRUE)))
  expect_true(is.character(get_uuid(name = "Acropora", n = 1, url = TRUE)))
  expect_true(length(get_uuid(name = NULL, n = 10)) == 10)
  expect_true(length(get_uuid(name = NULL, n = 10, url = TRUE)) == 10)
  expect_true(length(get_uuid(name = NULL, n = 10, filter = "by")) == 10)
  expect_true(length(get_uuid(name = NULL, n = 10, filter = "nc")) == 10)
  expect_true(length(get_uuid(name = NULL, n = 10, filter = "sa")) == 10)
  # Expect warnings
  expect_warning(is.character(get_uuid(name = "Acropora", n = 50, url = TRUE)))
  # Expect errors
  expect_error(get_uuid(name = 1))
  expect_error(get_uuid(n = 10, filter = "test"))
  expect_error(get_uuid(name = "Acropora cervicornis", url = 1))
  expect_error(get_uuid(name = "Acropora cervicornis", n = "5"))
})
