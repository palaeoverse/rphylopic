#' Get PhyloPic uuid(s)
#'
#' This function provides a convenient way to obtain a valid uuid or image url
#' for an input taxonomic name. As multiple silhouettes can exist for each
#' species in PhyloPic, this function extracts the primary image.
#'
#' @param name \code{character}. A taxonomic name. Different taxonomic levels
#'   are supported (i.e. species, genus, family).
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
#' @details This function returns uuid(s) or image url (svg) for an input 
#'   \code{name}. If a specific image is desired, the user can make use of
#'    \link{pick_phylo} to visually select the desired uuid/url.
#' @importFrom httr GET content
#' @importFrom jsonlite fromJSON
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
  if (!is.numeric(n)) {
    stop("`n` should be of class numeric.")
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
  # Error handling
  if ("errors" %in% names(api_return)) {
    stop(paste0("Image resource not available for `name`. \n",
                "Ensure provided name is a valid taxonomic name or ",
                "try a species/genus resolution name."))
  }
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
