test_that("pick_phylo works", {
  # Expect error
  expect_error(pick_phylo(name = "Dog"))
  expect_error(pick_phylo(name = 1))
  expect_error(pick_phylo(name = "Acropora", n = "5"))
})
