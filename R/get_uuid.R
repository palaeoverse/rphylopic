#' Get a PhyloPic uuid
#'
#' This function provides a convenient way to obtain a valid uuid or image url
#' for an input taxonomic name. As multiple silhouettes can exist for each
#' species in PhyloPic, this function extracts the primary image.
#'
#' @param name \code{character}. A taxonomic name. Various taxonomic levels
#'   are supported (e.g. species, genus, family). NULL can also be supplied
#'   which will skip the taxonomic filtering of the PhyloPic database.
#' @param n \code{numeric}. How many uuids should be returned? Depending
#'   on the requested `name`, multiple silhouettes might exist. If `n` exceeds
#'   the number of available images, all available uuids will be returned. This
#'   argument defaults to 1.
#' @param url \code{logical}. If \code{FALSE} (default), only the uuid is
#'   returned. If \code{TRUE}, a valid PhyloPic image url of the uuid is
#'   returned.
#'
#' @return A \code{character} vector of a valid PhyloPic uuid or svg image
#'   url.
#'
#' @details This function returns uuid(s) or image url (svg) for an input
#'   \code{name}. If a specific image is desired, the user can make use of
#'   [pick_phylopic] to visually select the desired uuid/url.
#' @importFrom stats setNames
#' @export
#' @examples
#' uuid <- get_uuid(name = "Acropora cervicornis")
#' uuid <- get_uuid(name = "Dinosauria", n = 5, url = TRUE)
get_uuid <- function(name = NULL, n = 1, url = FALSE) {
  # Error handling -------------------------------------------------------
  if (!is.null(name) && !is.character(name)) {
    stop("`name` should be `NULL` or of class character.")
  }
  if (!is.numeric(n)) {
    stop("`n` should be of class numeric.")
  }
  if (!is.logical(url)) {
    stop("`url` should be of class logical.")
  }
  # Normalise name -------------------------------------------------------
  name <- tolower(name)
  name <- gsub("_", " ", name)
  # API call -------------------------------------------------------------
  opts <- list()
  if (!is.null(name)) opts$filter_name <- name
  api_return <- phy_GET("images", opts)
  total_items <- api_return$totalItems
  if (total_items == 0) {
    stop(paste0("Image resource not available for `name`. \n",
                "Ensure provided name is a valid taxonomic name or ",
                "try a species/genus resolution name."))
  } else if (total_items < n) {
    warning(paste0("Only ", total_items, " items are available."))
    n <- total_items
  }
  n_pages <- ceiling(n / api_return$itemsPerPage)
  opts$embed_items <- if (url) "true" else "false"
  ret <- lapply(1:n_pages, function(i) {
    opts$page <- i - 1 # 0-based indexing
    api_return <- phy_GET("images", opts)
    # Extract uuids ---------------------------------------------------------
    uuids <- api_return$`_links`$items$href
    uuids <- sub("/images/", "", uuids)
    uuids <- sub("(\\?build=\\d+)$", "", uuids)
    
    # Get image URLs --------------------------------------------------------
    if (url) {
      href <- api_return$`_embedded`$items$`_links`$vectorFile$href
      uuids <- setNames(href, uuids)
    }
    uuids
  })
  ret <- do.call(c, ret)[1:n]
  return(ret)
}
