# Test helpers for the in-memory parsed-object cache
key_exists <- function(key) {
  exists(key, envir = .phy_cache, inherits = FALSE)
}
