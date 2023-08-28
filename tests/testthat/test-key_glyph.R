test_that("phylopic_key_glyph works", {
  skip_if_offline(host = "api.phylopic.org")
  df <- data.frame(x = c(2, 4), y = c(10, 20),
                   name = c("Felis silvestris catus", "Odobenus rosmarus"))
  gg <- ggplot(df) +
    geom_phylopic(aes(x = x, y = y, name = name, color = name), size = 10,
                  show.legend = TRUE, verbose = TRUE,
                  key_glyph = phylopic_key_glyph(name = df$name)) +
    coord_cartesian(xlim = c(1, 6), ylim = c(5, 30)) +
    theme_classic(base_size = 16)
  expect_true(is.ggplot(gg))
  expect_doppelganger("phylopic_key_glyph", gg)
  gg <- gg + theme(legend.key.size = grid::unit(5, "lines"))
  expect_doppelganger("phylopic_key_glyph with larger glyphs", gg)
})
