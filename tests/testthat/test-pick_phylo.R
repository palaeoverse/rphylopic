test_that("pick_phylopic works", {
  skip_if_offline(host = "api.phylopic.org")
  # Expect equal
  expect_true(is(pick_phylopic(name = "Acropora", n = 1),
                 "Picture"))
  expect_true(is(pick_phylopic(name = "Homo sapiens", n = 3, auto = 1),
                 "Picture"))
  expect_true(is(pick_phylopic(name = "Homo sapiens", n = 3, auto = 2),
                 "Picture"))
  # Expect error
  expect_error(pick_phylopic(name = "Dog"))
  expect_error(pick_phylopic(name = 1))
  expect_error(pick_phylopic(name = "Acropora", n = "5"))
  expect_error(pick_phylopic(name = "Homo sapiens", n = 3, auto = 0))
})
