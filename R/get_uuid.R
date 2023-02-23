#' Get single PhyloPic uuid
#'
#' This function provides a convenient way to obtain a valid uuid or image url
#' for an input taxonomic name. As multiple silhouettes can exist for each
#' species in PhyloPic, this function extracts the primary image.
#'
#' @param name \code{character}. A taxonomic name. Different taxonomic levels
#'   are supported (e.g. species, genus, family).
#' @param url \code{logical}. If \code{FALSE} (default), only the uuid is
#'   returned. If \code{TRUE}, a valid PhyloPic image url of the uuid is
#'   returned.
#'
#' @return A \code{character} vector of a valid PhyloPic uuid or .svg image
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
#' get_uuid(name = "Tyrannosaurus", url = TRUE)
get_uuid <- function(name = NULL, url = FALSE){
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
  base <- "https://api.phylopic.org/nodes?build=172"
  embed <- "&embed_items=true&embed_primaryImage=true"
  filter <- paste0("&filter_name=", name)
  page <- "&page=0"
  request <- paste0(base, embed, filter, page)
  api_return <- GET(url = request)

  # Extract uuid ----------------------------------------------------------
  uuid <- content(api_return, as = "text", encoding = "UTF-8")
  # Check if resource available
  if (grepl(pattern = "RESOURCE_NOT_FOUND", x = uuid)) {
    stop("Resource not found. Check input `name`.")
  }
  uuid <- sub("/vector.svg.*", "", uuid) 
  uuid <- sub(".*https://images.phylopic.org/images/", "", uuid) 
  
  # Build URL? ------------------------------------------------------------
  if (url) {
    uuid <- paste0("https://images.phylopic.org/images/", uuid, "/vector.svg")
  }
  return(uuid)
}
