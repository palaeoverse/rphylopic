test_that("get_phylopic cache makes second call faster", {
  skip_if_offline(host = phost())
  skip_on_cran()
  
  jay_id <- "f7a09e0a-7c42-4c68-adf9-25869322b811"
  
  # The parsed Picture is keyed by URL in .phy_cache
  # the API response is held in httpcache
  svg_key <- sprintf("https://images.phylopic.org/images/%s/vector.svg", jay_id)
  
  # Clear both caches to ensure a clean first call
  clear_phylopic_cache()
  expect_false(httpcache::hitCache(svg_key))
  expect_false(key_exists(svg_key))
  
  # First call: populates httpcache (SVG bytes response) and
  # .phy_cache (the parsed Picture object)
  t1 <- system.time(jay1 <- get_phylopic(jay_id))[["elapsed"]]
  expect_true(httpcache::hitCache(svg_key))
  expect_true(key_exists(svg_key))
  
  # Second call: parsed-object cache hits in get_svg
  # result must be identical and meaningfully faster
  # Error if GET is ever called
  testthat::local_mocked_bindings(
    GET = function(...) stop("network access not expected on cached call"),
    .package = "httr"
  )
  t2 <- system.time(jay2 <- get_phylopic(jay_id))[["elapsed"]]
  expect_identical(jay1, jay2)
  expect_lt(t2, t1 * 0.2)
})

test_that("get_phylopic raster cache makes second call faster", {
  skip_if_offline(host = phost())
  skip_on_cran()
  
  jay_id <- "f7a09e0a-7c42-4c68-adf9-25869322b811"
  height <- 512  # default height for get_phylopic raster format
  
  # make_png keys parsed PNG arrays by URL + height
  png_key <- sprintf("https://images.phylopic.org/images/%s/vector.svg", jay_id)
  png_height_key <- sprintf("https://images.phylopic.org/images/%s/vector.svg?h=%s",
                            jay_id, height)
  
  # Clear both caches to ensure a clean first call
  clear_phylopic_cache()
  expect_false(httpcache::hitCache(png_key))
  expect_false(key_exists(png_height_key))
  
  # First call: populates httpcache (SVG bytes response) and
  # .phy_cache (the parsed PNG array)
  t1 <- system.time(
    jay1 <- get_phylopic(jay_id, format = "raster", height = height)
  )[["elapsed"]]
  expect_true(httpcache::hitCache(png_key))
  expect_true(key_exists(png_height_key))
  
  # Second call: parsed-object cache hits in make_png
  # Error if GET is ever called
  testthat::local_mocked_bindings(
    GET = function(...) stop("network access not expected on cached call"),
    .package = "httr"
  )
  t2 <- system.time(
    jay2 <- get_phylopic(jay_id, format = "raster", height = height)
  )[["elapsed"]]
  expect_identical(jay1, jay2)
  expect_lt(t2, t1 * 0.2)
})

test_that("get_phylopic raster cache is keyed per height", {
  skip_if_offline(host = phost())
  skip_on_cran()
  
  jay_id <- "f7a09e0a-7c42-4c68-adf9-25869322b811"
  
  # make_png keys parsed PNG arrays by URL + height, so the same
  png_key <- sprintf("https://images.phylopic.org/images/%s/vector.svg", jay_id)
  png_key_height <- function(h) {
    sprintf("https://images.phylopic.org/images/%s/vector.svg?h=%s", jay_id, h)
  }
  
  clear_phylopic_cache()
  
  # First call at height 512: populates .phy_cache for that key only,
  # and populates httpcache for the SVG bytes
  jay512 <- get_phylopic(jay_id, format = "raster", height = 512)
  expect_true(httpcache::hitCache(png_key))
  expect_true(key_exists(png_key_height(512)))
  expect_false(key_exists(png_key_height(256)))
  
  # Second call at a different height misses the parsed-object cache
  # but hits httpcache for the SVG bytes
  # Error if GET is ever called
  testthat::local_mocked_bindings(
    GET = function(...) stop("network access not expected on cached call"),
    .package = "httr"
  )
  t_diff <- system.time(
    jay256 <- get_phylopic(jay_id, format = "raster", height = 256)
  )[["elapsed"]]
  expect_true(key_exists(png_key_height(256)))
  expect_true(key_exists(png_key_height(512)))  # original entry preserved
  
  # Different heights produce different output dimensions
  expect_false(identical(dim(jay256), dim(jay512)))
  
  # Third call at 256: parsed-object cache hits
  # Error if rsvg_png is ever called
  testthat::local_mocked_bindings(
    rsvg_png = function(...) stop("rasterization not expected on cached call"),
    .package = "rsvg"
  )
  jay256_repeat <- get_phylopic(jay_id, format = "raster", height = 256)
  expect_identical(jay256, jay256_repeat)
})
