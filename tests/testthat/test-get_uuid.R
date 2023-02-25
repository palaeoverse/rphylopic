test_that("get_uuid works", {
  skip_if_offline(host = "api.phylopic.org")
  # Expect true
  expect_true(is.character(get_uuid(name = "Acropora cervicornis")))
  expect_true(is.character(get_uuid(name = "Tyrannosaurus", url = TRUE)))
  expect_true(is.character(get_uuid(name = "Acropora", n = 10, url = TRUE)))
  
  # Expect errors
  expect_error(get_uuid(name = "Didgeridoo"))
  expect_error(get_uuid(name = NULL))
  expect_error(get_uuid(name = 1))
  expect_error(get_uuid(name = "Acropora cervicornis", url = 1))
  expect_error(get_uuid(name = "Acropora cervicornis", n = "5"))
})
