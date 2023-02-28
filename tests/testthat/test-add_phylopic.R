suppressPackageStartupMessages(library(ggplot2, quietly = TRUE))

test_that("add_phylopic works", {
  skip_if_offline(host = "api.phylopic.org")

  # phylopic in background, with name
  p <- ggplot(iris) +
    add_phylopic(name = "Iris", alpha = .2) +
    geom_point(aes(x = Sepal.Length, y = Sepal.Width))
  expect_doppelganger("phylopic in background", p)

  # png phylopic in background
  cat_png <- image_data("23cd6aa4-9587-4a2e-8e26-de42885004c9", size = "512")
  p <- ggplot(iris) +
    add_phylopic(cat_png, alpha = .2) +
    geom_point(aes(x = Sepal.Length, y = Sepal.Width))
  expect_doppelganger("phylopic png in background", p)

  # a bunch of little colored phylopics, with existing image
  set.seed(1234)
  posx <- runif(50, 0, 10)
  posy <- runif(50, 0, 10)
  sizey <- runif(50, 0.4, 2)
  cols <- sample(c("black", "darkorange", "grey42", "white"), 50,
    replace = TRUE)

  cat <- image_data("23cd6aa4-9587-4a2e-8e26-de42885004c9")
  p <- ggplot(data.frame(cat.x = posx, cat.y = posy), aes(cat.x, cat.y))
  for (i in 1:50) {
    p <- p + add_phylopic(cat, x = posx[i], y = posy[i],
                          ysize = sizey[i], color = cols[i])
  }
  p <- p + ggtitle("R Cat Herd!!")
  expect_doppelganger("phylopics on top of plot", p)

  # Expect error
  expect_error(add_phylopic(img = "cat"))
  expect_error(add_phylopic(cat, name = "cat"))
  expect_error(add_phylopic())
  expect_error(add_phylopic(cat, alpha = 3))
  expect_error(add_phylopic(name = 42))
  expect_error(add_phylopic(name = "bueller"))
  expect_error(add_phylopic(uuid = 42))
})
