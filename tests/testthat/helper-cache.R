# Test helpers for the in-memory parsed-object cache
key_exists <- function(key) {
  exists(key, envir = .phy_cache, inherits = FALSE)
}
id <- "f7a09e0a-7c42-4c68-adf9-25869322b811"
