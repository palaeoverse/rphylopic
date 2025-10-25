test_that("phy_GET cache makes second call faster", {
  skip_if_offline(host = phost())
  skip_on_cran()
  
  id <- "f7a09e0a-7c42-4c68-adf9-25869322b811"
  key_exists <- function(key) {
    exists(key, envir = .phy_cache, inherits = FALSE)
  }
  
  # Clear any existing cache
  key <- .cache_key("GET", file.path("images", id), NULL)
  if (key_exists(key)) {
    rm(list = key, envir = .phy_cache)
  }
  expect_false(key_exists(key))
  
  t1 <- system.time(jay1 <- get_phylopic(id))[["elapsed"]]
  expect_true(key_exists(key))
  
  # Check cache is being used by setting non-existent host
  real_phost <- phost
  phost <- function() "host.does.not.exist"
  t2 <- system.time(jay2 <- get_phylopic(id))[["elapsed"]]
  phost <- real_phost
  expect_identical(jay1, jay2)
  
  # Expect execution time to be faster when using cache
  expect_lt(t2, t1 * 0.8)
})
