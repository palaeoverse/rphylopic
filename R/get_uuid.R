#' Get a PhyloPic uuid
#'
#' This function provides a convenient way to obtain a valid uuid or image url
#' for an input taxonomic name. As multiple silhouettes can exist for each
#' species in PhyloPic, this function extracts the primary image.
#'
#' @param name \code{character}. A taxonomic name. Various taxonomic levels
#'   are supported (e.g. species, genus, family). NULL can also be supplied
#'   which will skip the taxonomic filtering of the PhyloPic database.
#' @param img A [Picture][grImport2::Picture-class] or png array object from
#'   [get_phylopic()]. A list of these objects can also be supplied. If `img`
#'   is supplied, `name` and `n` are ignored. Defaults to NULL.
#' @param n \code{numeric}. How many uuids should be returned? Depending on
#'   the requested `name`, multiple silhouettes might exist. If `n` exceeds
#'   the number of available images, all available uuids will be returned.
#'   This argument defaults to 1.
#' @param filter \code{character}. Filter uuid(s) by usage license. Use "by" to
#'   limit results to image uuids which do not require attribution, "nc" for
#'   image uuids which allow commercial usage, and "sa" for image uuids without
#'   a ShareAlike clause. The user can also combine these filters as a vector.
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
get_uuid <- function(name = NULL, img = NULL, n = 1, filter = NULL,
                     url = FALSE) {
  # Handle img -----------------------------------------------------------
  if (!is.null(img)) {
    if (is.list(img)) {
      uuid <- sapply(img, function(x) attr(x, "uuid"))
    } else {
      uuid <- attr(img, "uuid")
    }
    if (any(is.null(uuid))) {
      stop("uuid not available. Check `img` is from get_phylopic.")
    }
    if (url) {
      if (is.list(img)) {
        uuid <- sapply(img, function(x) attr(x, "url"))
      } else {
        uuid <- attr(img, "url")
      }
    }
    return(uuid)
  }
  # Error handling -------------------------------------------------------
  if (!is.null(name) && !is.character(name)) {
    stop("`name` should be `NULL` or of class character.")
  }
  if (!is.numeric(n)) {
    stop("`n` should be of class numeric.")
  }
  if (!is.null(filter) && !all(filter %in% c("by", "nc", "sa"))) {
    stop("`filter` should be NULL or either: 'by', 'nc', or 'sa'.")
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
  # Get clade uuid
  opts$page <- 0
  opts$embed_items <- "true"
  # Filter options
  if ("by" %in% filter) opts$filter_license_by <- "false"
  if ("nc" %in% filter) opts$filter_license_nc <- "false"
  if ("sa" %in% filter) opts$filter_license_sa <- "false"
  api_return <- phy_GET("nodes", opts)
  clade_uuid <- api_return$`_embedded`$items$uuid
  if (is.null(clade_uuid)) {
    # Attempt to use autocomplete for no matched data
    mch <- phy_GET("autocomplete", list(query = name))
    # Use first match (the best match)
    mch <- mch$matches
    # No match
    if (is.null(unlist(mch))) {
      stop(paste0("Image resource not available for '", name, "'. \n",
                  "Ensure provided name is a valid taxonomic name or ",
                  "try a species/genus resolution name."))
    } else {
      stop(paste0("Image resource not available for '", name, "'. ",
                  "Did you mean one of the following? \n", toString(mch)))
    }
  }
  # Reset options
  opts <- list()
  # First uuid should always be the closest link
  opts$filter_clade <- clade_uuid[1]
  # Filter options
  if ("by" %in% filter) opts$filter_license_by <- "false"
  if ("nc" %in% filter) opts$filter_license_nc <- "false"
  if ("sa" %in% filter) opts$filter_license_sa <- "false"
  api_return <- phy_GET("images", opts)
  total_items <- api_return$totalItems
  if (total_items < n) {
    warning(paste0("Only ", total_items, " item(s) are available."))
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
