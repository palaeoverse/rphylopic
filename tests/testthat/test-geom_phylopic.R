suppressPackageStartupMessages(library(ggplot2, quietly = TRUE))

test_that("geom_phylopic works", {
  skip_if_offline(host = "api.phylopic.org")
  df <- data.frame(x = 2:5, y = seq(10, 25, 5),
                   uuid = c("e25f1863-331b-4891-8084-fe8602e4cf8d",
                            "d2575005-1fcb-4a86-8c83-e3bda619adf2",
                            "c8f71c27-71db-4b34-ac2d-e97fea8762cf",
                            "0a8ab4f9-04c9-4485-b21a-df683d506055"))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y, uuid = uuid), color = "purple", size = 10,
                  horizontal = TRUE, angle = 45) +
    facet_wrap(~uuid) +
    coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
    theme_classic(base_size = 16)
  expect_true(is.ggplot(gg))
  expect_true(is(gg$layers[[1]]$geom, "GeomPhylopic"))
  expect_doppelganger("geom_phylopic", gg)

  cat_png <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9",
                          format = "raster")
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y), img = list(cat_png),
                  fill = "purple", size = 10) +
    coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
    theme_classic(base_size = 16)
  expect_doppelganger("geom_phylopic with png", gg)

  # Errors and warnings
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y, uuid = uuid), alpha = -5)
  expect_error(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y, uuid = uuid), name = "cat")
  expect_error(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y), name = -5)
  expect_error(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y), uuid = -5)
  expect_error(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y), img = -5)
  expect_error(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y), name = "asdfghjkl")
  expect_warning(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y), uuid = "asdfghjkl")
  expect_warning(plot(gg))
})
