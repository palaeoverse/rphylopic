test_that("get_uuid works", {
  # Expect true
  expect_true(is.character(get_uuid(name = "Acropora cervicornis")))
  expect_true(is.character(get_uuid(name = "Tyrannosaurus", url = TRUE)))
  
  # Expect errors
  expect_error(get_uuid(name = "Didgeridoo"))
  expect_error(get_uuid(name = NULL))
  expect_error(get_uuid(name = 1))
  expect_error(get_uuid(name = "Acropora cervicornis", url = 1))
  expect_error(get_uuid(name = "Acropora cervicornis", n = "5"))
})
