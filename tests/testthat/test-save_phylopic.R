test_that("save_phylopic works", {
  skip_if_offline(host = phost())
  # Get image
  img <- get_phylopic("918e22ea-53d9-4318-879d-1a3126968157")
  # Expect warning
  expect_warning(save_phylopic(img), NULL)
  # Remove generated file
  unlink(x = "./phylopic.png")
  # Expect error
  expect_error(save_phylopic(img, path = "./phylopic.eps"))
  expect_error(save_phylopic(img, path = "./phylopic.png", length = 200))
  expect_error(save_phylopic(img = NULL, path = "./phylopic.png"))
  expect_error(save_phylopic(img = "test", path = "./phylopic.png"))
})
