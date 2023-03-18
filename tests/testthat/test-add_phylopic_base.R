test_that("add_phylopic_base works", {
  skip_if_offline(host = "api.phylopic.org")

  # phylopic in background, with name
  expect_doppelganger("phylopic in background", function() {
    plot(1, 1, type = "n", main = "A cat")
    add_phylopic_base(name = "Cat")
  })

  # png phylopic in background
  expect_doppelganger("phylopic png in background", function() {
    cat_png <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9",
                            format = "512")
    plot(1, 1, type = "n", main = "A cat")
    add_phylopic_base(cat_png, x = 1, y = 1, ysize = .4, color = "blue",
                      alpha = .5, horizontal = TRUE)
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

  cat <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
  expect_doppelganger("phylopics on top of plot", function() {
    plot(posx, posy, type = "n", main = "A cat herd")
    for (i in 1:50) {
      add_phylopic_base(cat, x = posx[i], y = posy[i], ysize = sizey[i],
                        color = cols[i], alpha = alpha[i],
                        angle = angle[i],
                        horizontal = hor[i], vertical = ver[i])
    }
  })

  # Expect error
  expect_error(add_phylopic_base(img = "cat"))
  expect_error(add_phylopic_base(cat, name = "cat"))
  expect_error(add_phylopic_base())
  expect_error(add_phylopic_base(cat, alpha = 3))
  expect_error(add_phylopic_base(name = 42))
  expect_error(add_phylopic_base(name = "bueller"))
  expect_error(add_phylopic_base(uuid = 42))
})
