#' Get PhyloPic uuid
#'
#' This function provides a convenient way to obtain a valid uuid or image url
#' for an input taxonomic name. As multiple silhouettes can exist for each
#' species in PhyloPic, this function extracts the primary image.
#'
#' @param name \code{character}. A taxonomic name. Different taxonomic levels
#'   are supported (e.g. species, genus, family).
#' @param n \code{numeric}. How many uuids should be returned? Depending
#' on the requested `name`, multiple silhouettes might exist. If `n` exceeds
#' the number of available images, all available uuids will be returned. This
#' argument defaults to 1. 
#' @param url \code{logical}. If \code{FALSE} (default), only the uuid is
#'   returned. If \code{TRUE}, a valid PhyloPic image url of the uuid is
#'   returned.
#'
#' @return A \code{character} vector of a valid PhyloPic uuid or svg image
#'   url.
#'
#' @details This function provides a single uuid for an input \code{name}. If
#'   the returned uuid does not provide the desired image, the user might
#'   prefer to use **INSERT FUNCTION**. The uuid can also be returned as a
#'   valid image url (.svg file).
#' @importFrom httr GET content
#' @export
#' @examples
#' get_uuid(name = "Acropora cervicornis")
#' get_uuid(name = "Dinosauria", n = 5, url = TRUE)
get_uuid <- function(name = NULL, n = 1, url = FALSE){
  # Error handling -------------------------------------------------------
  if (is.null(name)) {
    stop("A taxonomic `name` is required (e.g. Acropora cervicornis).")
  }
  if (!is.character(name)) {
    stop("`name` should be of class character.")
  }
  if (!is.logical(url)) {
    stop("`url` should be of class logical.")
  }
  # Normalise name -------------------------------------------------------
  name <- tolower(name)
  name <- sub(" ", "%20", name)
  name <- sub("_", "%20", name)
  
  # API call -------------------------------------------------------------
  base <- "https://api.phylopic.org/images"
  # Get build
  build <- GET(url = "https://api.phylopic.org/")
  build <- content(build, as = "text", encoding = "UTF-8")
  build <- fromJSON(build)$build
  build <- paste0("?build=", build)
  embed <- "&embed_items=true"
  filter <- paste0("&filter_name=", name)
  page <- "&page=0"
  # Request
  request <- paste0(base, build, embed, filter, page)
  api_return <- GET(url = request)
  api_return <- content(api_return, as = "text", encoding = "UTF-8")
  api_return <- fromJSON(api_return)
  
  # Extract uuid ----------------------------------------------------------
  uuids <- api_return$`_links`$items$href
  uuids <- sub("/images/", "", uuids)
  uuids <- sub(build, "", uuids, fixed = TRUE)
  # Update n if greater than available uuids 
  if (n > length(uuids)) {
    n <- length(uuids)
  }
  # Extract n uuids
  uuids <- uuids[1:n]

  # Build URL? ------------------------------------------------------------
  if (url) {
    uuids <- paste0("https://images.phylopic.org/images/", uuids, 
                    "/vector.svg")
  }
  return(uuids)
}
