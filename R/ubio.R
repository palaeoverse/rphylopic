#' Perform actions with uBio data.
#'
#' @name ubio
#' @param namebankID The identifier for a name in uBio Namebank.
#' @param options (character) One or more of citationStart, html, namebankID,
#' root, string, type, uid, uri, and/or votes
#' @param ... curl options passed on to [crul::HttpClient]
#' @details There is only one function for working with uBio data right now, 
#' `ubio_get()`
#'
#' Options for the `options` parameter: Same as those for `name_*()` functions.
#' @examples \dontrun{
#' # Retrieves information on a set of taxonomic names.
#' ubio_get(109086)
#' ubio_get(109086, options=c('names','string'))
#' }

#' @export
#' @rdname ubio
ubio_get <- function(namebankID, options=NULL, ...) {
    phy_GET(file.path("api/a/ubio/name", namebankID), collops(options), 
        ...)$result
}
