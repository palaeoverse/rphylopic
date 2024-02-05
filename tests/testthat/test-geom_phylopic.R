suppressPackageStartupMessages(library(ggplot2, quietly = TRUE))

test_that("geom_phylopic works", {
  skip_if_offline(host = "api.phylopic.org")
  try(dev.off(), silent = TRUE) # clean up any stray plots

  df <- data.frame(x = 2:5, y = seq(10, 25, 5),
                   uuid = c("e25f1863-331b-4891-8084-fe8602e4cf8d",
                            "d2575005-1fcb-4a86-8c83-e3bda619adf2",
                            "c8f71c27-71db-4b34-ac2d-e97fea8762cf",
                            "0a8ab4f9-04c9-4485-b21a-df683d506055"))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y, uuid = uuid), color = "purple", height = 10,
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
                  fill = "purple", height = 10) +
    coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
    theme_classic(base_size = 16)
  expect_doppelganger("geom_phylopic with png", gg)

  # Errors and warnings
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y, uuid = uuid), alpha = -5)
  expect_error(plot(gg))
  expect_error(ggplot(df) +
                 geom_phylopic(aes(x = x, y = y, uuid = uuid), remove_background = "yes"))
  expect_error(ggplot(df) +
                 geom_phylopic(aes(x = x, y = y, uuid = uuid), verbose = "yes"))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y, uuid = uuid), name = "cat", verbose = TRUE)
  expect_error(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y), name = -5, verbose = TRUE)
  expect_error(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y), uuid = -5)
  expect_error(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y), img = -5)
  expect_error(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y), name = "asdfghjkl", verbose = TRUE)
  expect_warning(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y), uuid = "asdfghjkl")
  expect_warning(plot(gg))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y, uuid = uuid), height = 1E-6)
  expect_warning(plot(gg))
})

test_that("phylopic_key_glyph works", {
  skip_if_offline(host = "api.phylopic.org")
  try(dev.off(), silent = TRUE) # clean up any stray plots

  df <- data.frame(x = c(2, 4), y = c(10, 20),
                   name = c("Felis silvestris catus", "Odobenus rosmarus"))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y, name = name, color = name), height = 10,
                  show.legend = TRUE, verbose = TRUE,
                  key_glyph = phylopic_key_glyph(name = df$name)) +
    coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
    theme_classic(base_size = 16)
  expect_doppelganger("phylopic_key_glyph", gg)
  
  gg <- gg + theme(legend.key.size = grid::unit(5, "lines"))
  expect_doppelganger("phylopic_key_glyph with larger glyphs", gg)

  gg <- ggplot(df) +
    geom_phylopic(
      aes(x = x, y = y, name = name, color = name), height = 10,
      show.legend = TRUE, verbose = TRUE,
      key_glyph =
        phylopic_key_glyph(uuid = c("23cd6aa4-9587-4a2e-8e26-de42885004c9",
                                    "16cfde1b-d577-4de8-82b9-62b760aacba5"))
    ) +
    coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
    theme_classic(base_size = 16)
  expect_doppelganger("phylopic_key_glyph with uuid", gg)

  cat <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y, name = name, color = name), height = 10,
                  show.legend = TRUE, verbose = TRUE,
                  key_glyph = phylopic_key_glyph(img = cat)) +
    coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
    theme_classic(base_size = 16)
  expect_doppelganger("phylopic_key_glyph with img", gg)
  
  # errors/warnings
  expect_error(ggplot(df) +
                 geom_phylopic(
                   aes(x = x, y = y, name = name, color = name), height = 10,
                   show.legend = TRUE, verbose = TRUE,
                   key_glyph =
                     phylopic_key_glyph(
                       uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
                       img = cat
                     )
                 ) +
                 coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
                 theme_classic(base_size = 16))
  expect_error(ggplot(df) +
                 geom_phylopic(
                   aes(x = x, y = y, name = name, color = name), height = 10,
                   show.legend = TRUE, verbose = TRUE,
                   key_glyph =
                     phylopic_key_glyph(name = 12345)
                 ) +
                 coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
                 theme_classic(base_size = 16))
  expect_warning(ggplot(df) +
                   geom_phylopic(
                     aes(x = x, y = y, name = name, color = name), height = 10,
                     show.legend = TRUE, verbose = TRUE,
                     key_glyph =
                       phylopic_key_glyph(name = "12345")
                   ) +
                   coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
                   theme_classic(base_size = 16))
  expect_error(ggplot(df) +
                 geom_phylopic(
                   aes(x = x, y = y, name = name, color = name), height = 10,
                   show.legend = TRUE, verbose = TRUE,
                   key_glyph =
                     phylopic_key_glyph(uuid = 12345)
                 ) +
                 coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
                 theme_classic(base_size = 16))
  expect_warning(ggplot(df) +
                   geom_phylopic(
                     aes(x = x, y = y, name = name, color = name), height = 10,
                     show.legend = TRUE, verbose = TRUE,
                     key_glyph =
                       phylopic_key_glyph(uuid = "12345")
                   ) +
                   coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
                   theme_classic(base_size = 16))
  expect_error(ggplot(df) +
                 geom_phylopic(
                   aes(x = x, y = y, name = name, color = name), height = 10,
                   show.legend = TRUE, verbose = TRUE,
                   key_glyph =
                     phylopic_key_glyph(img = 12345)
                 ) +
                 coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
                 theme_classic(base_size = 16))
})
