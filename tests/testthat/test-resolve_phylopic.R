test_that("resolve_phylopic works with GBIF", {
  skip_if_offline(host = "api.gbif.org")
  res <- resolve_phylopic(name = "Acropora cervicornis", api = "gbif.org")
  expect_equal(length(res), 1)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  suppressWarnings(
    res <- resolve_phylopic(name = "Acropora cervicornis", api = "gbif.org",
                            n = 5)
  )
  expect_equal(length(res), 1)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  res <- resolve_phylopic(name = "Acropora cervicornis", api = "gbif.org",
                          hierarchy = TRUE, max_ranks = 5)
  expect_equal(length(res), 5)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  expect_error(resolve_phylopic(name = "fdsafdsafdas;fdsaf",
                                api = "gbif.org"))
  expect_error(resolve_phylopic(name = "Acropora cervicornis",
                                api = "gbif.org", n = "hi"))
  expect_error(resolve_phylopic(name = "Acropora cervicornis",
                                api = "gbif.org", hierarchy = "hi"))
  expect_error(resolve_phylopic(name = "Acropora cervicornis",
                                api = "gbif.org", max_ranks = "hi"))
  expect_error(resolve_phylopic(name = 15, api = "gbif.org"))
  expect_error(resolve_phylopic(name = "Acropora cervicornis", api = "hi"))
})

test_that("resolve_phylopic works with EOL", {
  skip_if_offline(host = "eol.org")
  res <- resolve_phylopic(name = "Enhydra lutris", api = "eol.org")
  expect_equal(length(res), 1)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  suppressWarnings(
    res <- resolve_phylopic(name = "Enhydra lutris", api = "eol.org",
                            n = 5)
  )
  expect_equal(length(res), 1)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  expect_warning({
    res <- resolve_phylopic(name = "Enhydra lutris", api = "eol.org",
                            hierarchy = TRUE, max_ranks = 5)
  })
  expect_equal(length(res), 1)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  expect_error(resolve_phylopic(name = "fdsafdsafdas;fdsaf",
                                api = "eol.org"))
})

test_that("resolve_phylopic works with WoRMS", {
  skip_if_offline(host = "marinespecies.org")
  res <- resolve_phylopic(name = "Enhydra lutris", api = "marinespecies.org")
  expect_equal(length(res), 1)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  suppressWarnings(
    res <- resolve_phylopic(name = "Enhydra lutris", api = "marinespecies.org",
                            n = 5)
  )
  expect_equal(length(res), 1)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  res <- resolve_phylopic(name = "Enhydra lutris", api = "marinespecies.org",
                          hierarchy = TRUE, max_ranks = 5)
  expect_equal(length(res), 5)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  expect_error(resolve_phylopic(name = "fdsafdsafdas;fdsaf",
                                api = "marinespecies.org"))
})

test_that("resolve_phylopic works with PBDB", {
  skip_if_offline(host = "paleobiodb.org")
  res <- resolve_phylopic(name = "Velociraptor mongoliensis",
                          api = "paleobiodb.org")
  expect_equal(length(res), 1)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  res <- resolve_phylopic(name = "Velociraptor mongoliensis",
                          api = "paleobiodb.org", n = 5)
  expect_equal(length(res), 1)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  res <- resolve_phylopic(name = "Velociraptor mongoliensis",
                          api = "paleobiodb.org", hierarchy = TRUE)
  expect_equal(length(res), 5)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  expect_error(resolve_phylopic(name = "fdsafdsafdas;fdsaf",
                                api = "paleobiodb.org"))
})

test_that("resolve_phylopic works with OTOL", {
  skip_if_offline(host = "opentreeoflife.org")
  res <- resolve_phylopic(name = "Canis lupus", api = "opentreeoflife.org")
  expect_equal(length(res), 1)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  res <- resolve_phylopic(name = "Canis lupus", api = "opentreeoflife.org",
                          n = 5)
  expect_equal(length(res), 1)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  res <- resolve_phylopic(name = "Canis lupus", api = "opentreeoflife.org",
                          hierarchy = TRUE, max_ranks = 5)
  expect_equal(length(res), 5)
  expect_true(is.character(names(res)))
  expect_true(all(sapply(res, is.character)))

  expect_error(resolve_phylopic(name = "fdsafdsafdas;fdsaf",
                                api = "opentreeoflife.org"))
})
