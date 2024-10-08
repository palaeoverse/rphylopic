suppressPackageStartupMessages(library(ggplot2, quietly = TRUE))

test_that("add_phylopic works", {
  skip_if_offline(host = "api.phylopic.org")
  try(dev.off(), silent = TRUE) # clean up any stray plots

  # phylopic in background, with name
  p <- ggplot(iris) +
    add_phylopic(x = 6.1, y = 3.2, name = "Iris", alpha = 0.2, verbose = TRUE) +
    geom_point(aes(x = Sepal.Length, y = Sepal.Width))
  expect_doppelganger("phylopic in background", p)

  # png phylopic in background
  cat_png <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9",
                          format = "raster")
  p <- ggplot(iris) +
    add_phylopic(cat_png, x = 6.1, y = 3.2, alpha = 0.2, angle = 90,
                 horizontal = TRUE) +
    geom_point(aes(x = Sepal.Length, y = Sepal.Width))
  expect_doppelganger("phylopic png in background", p)

  # a bunch of little colored phylopics, with existing image
  set.seed(1234)
  posx <- runif(10, 0, 10)
  posy <- runif(10, 0, 10)
  sizey <- runif(10, 0.4, 2)
  angle <- runif(10, 0, 360)
  hor <- sample(c(TRUE, FALSE), 10, TRUE)
  ver <- sample(c(TRUE, FALSE), 10, TRUE)
  fills <- sample(c("black", "darkorange", "grey42", "white"), 10,
                 replace = TRUE)
  cols <- ifelse(fills == "white", "black", NA)
  alpha <- runif(10, 0, 1)

  p <- ggplot(data.frame(cat.x = posx, cat.y = posy), aes(cat.x, cat.y)) +
    geom_blank() +
    add_phylopic(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
                 x = posx, y = posy, height = sizey,
                 fill = fills, color = cols, alpha = alpha,
                 angle = angle, horizontal = hor, vertical = ver)
  expect_doppelganger("phylopics on top of plot", p)
  
  p <- ggplot(data.frame(cat.x = posx, cat.y = posy), aes(cat.x, cat.y)) +
    geom_blank() +
    add_phylopic(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
                 x = posx, y = posy, width = sizey,
                 fill = fills, color = cols, alpha = alpha,
                 angle = angle, horizontal = hor, vertical = ver)
  expect_doppelganger("phylopics with widths", p)

  p <- ggplot(data.frame(cat.x = posx, cat.y = posy), aes(cat.x, cat.y)) +
    geom_blank() +
    add_phylopic(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
                 x = posx, y = posy,
                 width = c(1, NA, 2, NA), height = c(NA, 1, NA, 2),
                 fill = fills, color = cols, alpha = alpha,
                 angle = angle, horizontal = hor, vertical = ver)
  expect_doppelganger("phylopics with alt height and width", p)

  lifecycle::expect_deprecated({
    p <- ggplot(data.frame(cat.x = posx, cat.y = posy), aes(cat.x, cat.y)) +
      geom_blank() +
      add_phylopic(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
                   x = posx, y = posy, ysize = sizey)
    plot(p)
  })

  p <- ggplot(data.frame(cat.x = posx, cat.y = posy), aes(cat.x, cat.y)) +
    geom_blank()
  cat_svg <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
  # Expect error
  expect_error(add_phylopic(img = "cat"))
  expect_error(add_phylopic(cat_svg, name = "cat"))
  expect_error(add_phylopic())
  expect_error({
    plot(p + add_phylopic(cat_svg, alpha = 3, x = 5, y = 5))
  })
  expect_error({
    plot(p + add_phylopic(cat_svg, hjust = 3, x = 5, y = 5))
  })
  expect_error({
    plot(p + add_phylopic(cat_svg, vjust = 3, x = 5, y = 5))
  })
  expect_error({
    plot(p + add_phylopic(name = 42, x = 5, y = 5, verbose = TRUE))
  })
  expect_error({
    plot(p + add_phylopic(uuid = 42, x = 5, y = 5, verbose = TRUE))
  })

  # Expect warning
  expect_warning({
    plot(p + add_phylopic(name = "bueller", x = 5, y = 5, verbose = TRUE))
  })
})
