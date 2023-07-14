#' Browse PhyloPic for a given taxonomic name or uuid
#'
#' This function provides a convenient way to browse PhyloPic for a given 
#' taxonomic name of uuid.
#'
#' @param name \code{character}. A taxonomic name. Various taxonomic levels
#'   are supported (e.g. species, genus, family).
#' @param uuid \code{character}. A PhyloPic image uuid, as acquired by 
#'  [get_uuid()].
#'
#' @return A \code{character} vector of a valid PhyloPic url for the specified
#'  \code{name} or \code{uuid}. If no \code{name} or \code{uuid} is supplied,
#'  the base url of PhyloPic images is returned.
#'
#' @details This function returns a PhyloPic url for an input \code{name} or
#'   \code{uuid} and opens the user's default web browser at this url. If no
#'   \code{name} or \code{uuid} is supplied, the base url of PhyloPic images
#'   is returned and opened instead.
#'   
#' @importFrom utils browseURL
#' @export
#' @examples
#' url <- browse_phylopic(name = "Acropora cervicornis")
browse_phylopic <- function(name = NULL, uuid = NULL) {
  # Error handling -------------------------------------------------------
  if (!is.null(name) && !is.character(name)) {
    stop("`name` should be `NULL` or of class character.")
  }
  if (!is.null(uuid) && !is.character(uuid)) {
    stop("`uuid` should be `NULL` or of class character.")
  }
  if (!is.null(name) && !is.null(uuid)) {
    stop("Both `name` and `uuid` are supplied. Supply only one.")
  }
  # Open browser ---------------------------------------------------------
  url <- "https://www.phylopic.org/images/"
  
  if (!is.null(name)) {
    uuid <- get_uuid(name = name)
  }
  
  url <- paste0(url, uuid)
  browseURL(url = url)

  return(url)
}
