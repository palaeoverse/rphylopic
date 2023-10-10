test_that("add_phylopic_base works", {
  skip_if_offline(host = "api.phylopic.org")

  # phylopic in background, with name
  expect_doppelganger("phylopic in background", function() {
    plot(1, 1, type = "n", main = "A cat")
    add_phylopic_base(name = "Felis silvestris catus", ysize = .7,
                      verbose = TRUE)
  })

  # png phylopic in background
  expect_doppelganger("phylopic png in background", function() {
    cat_png <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9",
                            format = "raster")
    plot(1, 1, type = "n", main = "A cat")
    add_phylopic_base(cat_png, x = 1, y = 1, ysize = .4, fill = "blue",
                      alpha = .5, angle = -90, horizontal = TRUE)
  })

  # a bunch of little colored phylopics, with existing image
  set.seed(1234)
  posx <- runif(50, 0, 10)
  posy <- runif(50, 0, 10)
  sizey <- runif(50, 0.4, 2)
  angle <- runif(50, 0, 360)
  hor <- sample(c(TRUE, FALSE), 50, TRUE)
  ver <- sample(c(TRUE, FALSE), 50, TRUE)
  cols <- sample(c("black", "darkorange", "grey42", "white"), 50,
                 replace = TRUE)
  alpha <- runif(50, 0, 1)

  expect_doppelganger("phylopics on top of plot", function() {
    plot(posx, posy, type = "n", main = "A cat herd")
    add_phylopic_base(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
                      x = posx, y = posy, ysize = sizey,
                      color = cols, alpha = alpha,
                      angle = angle,
                      horizontal = hor, vertical = ver)
  })

  # Expect warning
  expect_warning(add_phylopic_base(name = "cat", verbose = FALSE))
  expect_error(expect_warning(add_phylopic_base(name = "jkl;daf",
                                                verbose = TRUE)))
  expect_warning(add_phylopic_base(uuid = "jkl;daf", filter = "by"))
  
  # Expect error
  expect_error(add_phylopic_base(img = "cat"))
  expect_error(add_phylopic_base(img = cat, verbose = "yes"))
  expect_error(add_phylopic_base(cat, name = "cat"))
  expect_error(add_phylopic_base())
  expect_error(add_phylopic_base(cat, alpha = 3))
  expect_error(add_phylopic_base(name = 42))
  expect_error(add_phylopic_base(uuid = 42))
})
