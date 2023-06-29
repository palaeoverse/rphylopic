test_that("get_phylopic works", {
  # uuid
  uuid <- "9fae30cd-fb59-4a81-a39c-e1826a35f612"

  # Expect true
  expect_true(is(get_phylopic(uuid = uuid, format = "vector"), "Picture"))
  expect_true(is(get_phylopic(uuid = uuid, format = "raster"), "array"))
  expect_true(is(get_phylopic(uuid = uuid, format = "raster",
                              height = 300), "array"))

  # Expect error
  expect_error(get_phylopic(uuid = 1))
  expect_error(get_phylopic(uuid = c("1", 2)))
  expect_error(get_phylopic(uuid = NULL))
  expect_error(get_phylopic(uuid = uuid, format = "VHS"))

  # 512 was deprecated for format
  expect_warning(get_phylopic(uuid = "c8f71c27-71db-4b34-ac2d-e97fea8762cf",
                              format = "512"))
})
