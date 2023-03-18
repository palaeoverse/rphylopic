test_that("flip_phylopic works", {
  skip_if_offline(host = "api.phylopic.org")
  cat <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
  expect_true(is(flip_phylopic(cat), "Picture"))
  expect_equal(diff(cat@summary@xscale),
               diff(flip_phylopic(cat, horizontal = TRUE)@summary@xscale))
  expect_equal(diff(cat@summary@yscale),
               diff(flip_phylopic(cat, horizontal = FALSE,
                                  vertical = TRUE)@summary@yscale))
  cat_flipped <- flip_phylopic(cat, horizontal = TRUE, vertical = TRUE)
  expect_equal(diff(cat@summary@xscale), diff(cat_flipped@summary@xscale))
  expect_equal(diff(cat@summary@yscale), diff(cat_flipped@summary@yscale))

  cat_png <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9",
                          format = "512")
  expect_equal(dim(cat_png),
               dim(flip_phylopic(cat_png, horizontal = TRUE, vertical = TRUE)))

  # Expect error
  expect_error(flip_phylopic(array(1, dim = c(5, 5, 2)), horizontal = "yes"))
  expect_error(flip_phylopic(array(1, dim = c(5, 5, 2)), vertical = "yes"))
  expect_error(flip_phylopic(array(1, dim = c(5, 5))))
})

test_that("rotate_phylopic works", {
  skip_if_offline(host = "api.phylopic.org")
  cat <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
  expect_true(is(rotate_phylopic(cat), "Picture"))
  expect_true(all.equal(rotate_phylopic(cat)@summary@yscale,
                        rev(cat@summary@xscale)))
  expect_true(all.equal(rotate_phylopic(cat, 180)@summary@xscale,
                        cat@summary@xscale - cat@summary@xscale[2]))
  cat_png <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9",
                          format = "512")
  expect_equal(rev(dim(cat_png)[1:2]), dim(rotate_phylopic(cat_png))[1:2])

  # Expect error
  expect_error(rotate_phylopic(cat, angle = "clockwise"))
  expect_error(rotate_phylopic(cat_png, angle = 150))
  expect_error(rotate_phylopic(array(1, dim = c(5, 5))))
})

test_that("recolor_phylopic works", {
  skip_if_offline(host = "api.phylopic.org")
  cat <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
  cat_recolor <- recolor_phylopic(cat, .5, "red")
  expect_true(is(cat_recolor, "Picture"))
  expect_equal(cat_recolor@content[[1]]@content[[1]]@gp$fill, "red")
  expect_equal(cat_recolor@content[[1]]@content[[1]]@gp$alpha, .5)

  cat_png <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9",
                          format = "512")
  cat_recolor <- recolor_phylopic(cat_png, .9, "purple")
  expect_equal(dim(recolor_phylopic(cat_png[, , 1, drop = FALSE], .5, "red")),
               dim(cat_recolor))
  expect_equal(dim(recolor_phylopic(cat_recolor[, , 1:3, drop = FALSE], .2)),
               dim(cat_recolor))
  cols <- col2rgb("purple")[, 1] / 255
  expect_true(all(cat_recolor[, , 1] == cols["red"]))
  expect_true(all(cat_recolor[, , 2] == cols["green"]))
  expect_true(all(cat_recolor[, , 3] == cols["blue"]))
  expect_equal(max(cat_recolor[, , 4]), .9)

  cat_recolor <- recolor_phylopic(cat_png, .5)
  expect_equal(max(cat_recolor[, , 4]), .5)

  # Expect error
  expect_error(recolor_phylopic(cat, alpha = "transparent"))
  expect_error(recolor_phylopic(cat, color = 0))
  expect_error(recolor_phylopic(array(1, dim = c(5, 5))))
  expect_error(recolor_phylopic(array(1, dim = c(5, 5, 5))))
})
