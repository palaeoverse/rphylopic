#' Perform actions with name sets
#'
#' @name nameset
#' @param uuid One or more name UUIDs.
#' @param options (character) One or more of citationStart, html, namebankID, root, string,
#' type, uid, uri, and/or votes
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @details I'm not adding methods for adding names because I can't imagine doing that in R. 
#' Am I wrong?
#'
#' Options for the \code{options} parameter: Same as those for \code{name_*()} functions.
#' @examples \dontrun{
#' # Retrieves information on a set of taxonomic names.
#' id <- "8d9a9ea3-95cc-414d-1000-4b683ce04be2"
#' nameset_get(uuid = id)
#' nameset_get(uuid = id, options=c('names','string'))
#'
#' # Collects taxonomic data for a name.
#' nameset_taxonomy(uuid = "8d9a9ea3-95cc-414d-1000-4b683ce04be2", options = "string")
#' nameset_taxonomy(uuid = "8d9a9ea3-95cc-414d-1000-4b683ce04be2", supertaxa="immediate",
#'    options=c("string","namebankID"))
#' }

#' @export
#' @rdname nameset
nameset_get <- function(uuid, options=NULL, ...) phy_GET(paste0(nsbase(), uuid), collops(options), ...)$result

#' @export
#' @rdname nameset
nameset_taxonomy <- function(uuid, options=NULL, ...) phy_GET(paste0(nsbase(), uuid, "/taxonomy"), collops(options), ...)$result

nsbase <- function() "http://phylopic.org/api/a/name/set/"
