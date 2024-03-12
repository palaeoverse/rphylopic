test_that("pick_phylopic works", {
  skip_if_offline(host = "api.phylopic.org")

  # Expect equal
  expect_true(is(pick_phylopic(name = "Acropora", n = 1),
                 "Picture"))
  expect_true(is(pick_phylopic(name = "Homo sapiens", n = 3, auto = 1),
                 "Picture"))
  expect_true(is(pick_phylopic(name = "Homo sapiens", n = 3, auto = 2),
                 "Picture"))
  expect_true(is(pick_phylopic(name = "Bacteria", n = 13,
                               view = 5, auto = 2),
                 "Picture"))
  
  # Test attribution information
  expect_equal(
    length(pick_phylopic(name = "Scleractinia", n = 4, view = 4, auto = 3)),
           4)

  # Expect warning
  expect_warning(pick_phylopic(name = "Acropora cervicornis", n = 10))

  # Expect error
  expect_error(pick_phylopic(name = "Dog"))
  expect_error(pick_phylopic(name = 1))
  expect_error(pick_phylopic(name = "Acropora", n = "5"))
  expect_error(pick_phylopic(name = "Homo sapiens", n = 3, auto = 0))
  expect_error(pick_phylopic(name = "Acropora", ncol = NULL))
  expect_error(pick_phylopic(name = "Acropora", view = "5"))
})
