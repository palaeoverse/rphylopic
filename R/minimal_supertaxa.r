#' Finds the minimal common supertaxa for a list of names.
#' 
#' @keywords internal
#' @param nameUIDs Space-separated list of UUIDs for taxonomic names.
#' @param options Space-separated list of options for the result value.
#' @param ... curl options passed on to [crul::HttpClient]
#' @details Here are the options for the options argument:
#' 
#' - citationStart: (optional) Integer Indicates where in the string the citation starts. 
#'  May be null.
#' - html: (optional) StringHTML version of the name.
#' - namebankID: (optional) StringuBio Namebank identifier. May be null.
#' - root: (optional) Boolean If true, this name has no hyperonyms (names of supertaxa). 
#'  (Should only be true for Panbiota/Vitae.)
#' - string: (optional) String The text of the name, including the citation, if any.
#' - type: (optional) String Either "scientific or "vernacular.
#' - uid: (always) String Universally unique identifier.
#' - uri: (optional) String The unique URI associated with the name.
#' - votes: (optional) Integer The number of votes this name has received. (Currently unused.)
minimal_supertaxa <- function(nameUIDs, options = NULL, ...) {
  args <- pc(list(nameUIDs = paste(nameUIDs, collapse = " "), 
    options = options))
  x <- phy_GET('api/a/name/minSupertaxa', args, ...)
  x$result[[1]]$canonicalName$uid
}
