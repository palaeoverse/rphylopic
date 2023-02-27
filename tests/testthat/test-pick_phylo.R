test_that("pick_phylo interactively works", {
  # Skip if not interactive, select 2 for full coverage
  skip_if_not(interactive(), pick_phylo(name = "Homo sapiens", n = 2))
})

test_that("pick_phylo works", {
  # Expect equal
  expect_true(is(pick_phylo(name = "Acropora", n = 1), "Picture"))
  
  # Expect error
  expect_error(pick_phylo(name = "Dog"))
  expect_error(pick_phylo(name = 1))
  expect_error(pick_phylo(name = "Acropora", n = "5"))
})
