#' Perform actions with name sets
#'
#' @name nameset
#' @param uuid the UUID of a set of taxonomic names
#' @param options (character) One or more of citationStart, html,
#' namebankID, root, string, type, uid, uri, and/or votes
#' @param ... curl options passed on to [crul::HttpClient]
#' @details `nameset_get()` retrieves information on a set of taxonomic
#' names. `nameset_taxonomy()` collects taxonomic data for a set of
#' taxonomic names. 
#' 
#' @section `options` parameter:
#' Same as those for `name_*()` functions
#' @return a named list
#' @examples \dontrun{
#' # Retrieves information on a set of taxonomic names.
#' id <- "8d9a9ea3-95cc-414d-1000-4b683ce04be2"
#' nameset_get(uuid = id)
#' nameset_get(uuid = id, options=c('names','string'))
#'
#' # Collects taxonomic data for a name.
#' nameset_taxonomy(uuid = "8d9a9ea3-95cc-414d-1000-4b683ce04be2",
#'   options = "string")
#' nameset_taxonomy(uuid = "8d9a9ea3-95cc-414d-1000-4b683ce04be2",
#'   supertaxa="immediate", options=c("string","namebankID"))
#' }

#' @export
#' @rdname nameset
nameset_get <- function(uuid, options=NULL, ...) {
  phy_GET(file.path("api/a/name/set", uuid), collops(options), ...)$result
}

#' @export
#' @rdname nameset
nameset_taxonomy <- function(uuid, options=NULL, ...) {
  phy_GET(file.path("api/a/name/set", uuid, "taxonomy"),
    collops(options), ...)$result
}
