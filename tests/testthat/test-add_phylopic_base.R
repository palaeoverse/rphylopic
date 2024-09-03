test_that("add_phylopic_base works", {
  skip_if_offline(host = "api.phylopic.org")

  # phylopic in background, with name
  expect_doppelganger("phylopic in background", function() {
    plot(1, 1, type = "n", main = "A cat")
    add_phylopic_base(name = "Felis silvestris catus", height = .7,
                      verbose = TRUE)
  })
  
  expect_doppelganger("phylopic with width", function() {
    plot(1, 1, type = "n", main = "A cat")
    add_phylopic_base(name = "Felis silvestris catus", width = .4,
                      verbose = TRUE)
  })

  # png phylopic in background
  expect_doppelganger("phylopic png in background", function() {
    cat_png <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9",
                            format = "raster")
    plot(1, 1, type = "n", main = "A cat")
    add_phylopic_base(cat_png, x = 1, y = 1, height = .4, fill = "blue",
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
  fills <- sample(c("black", "darkorange", "grey42", "white"), 50,
                  replace = TRUE)
  cols <- ifelse(fills == "white", "black", NA)
  alpha <- runif(50, 0, 1)

  expect_doppelganger("phylopics on top of plot", function() {
    plot(posx, posy, type = "n", main = "A cat herd")
    add_phylopic_base(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
                      x = posx, y = posy, height = sizey,
                      fill = fills, color = cols, alpha = alpha,
                      angle = angle,
                      horizontal = hor, vertical = ver)
  })

  # Expect warning
  expect_warning(add_phylopic_base(name = "cat", verbose = FALSE))
  expect_error(expect_warning(add_phylopic_base(name = "jkl;daf",
                                                verbose = TRUE)))
  expect_warning(add_phylopic_base(uuid = "jkl;daf", filter = "by"))
  
  cat_svg <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
  lifecycle::expect_deprecated({
    add_phylopic_base(cat_svg, ysize = .7)
  })
  
  # Expect error
  expect_error(add_phylopic_base(img = "cat"))
  expect_error(add_phylopic_base(img = cat_svg, verbose = "yes"))
  expect_error(add_phylopic_base(cat_svg, name = "cat"))
  expect_error(add_phylopic_base())
  expect_error(add_phylopic_base(cat_svg, alpha = 3))
  expect_error(add_phylopic_base(name = 42))
  expect_error(add_phylopic_base(uuid = 42))
  expect_error(add_phylopic_base(cat_svg, height = 5, width = 5))
  expect_error(add_phylopic_base(cat_svg, hjust = 5))
  expect_error(add_phylopic_base(cat_svg, vjust = 5))
})
