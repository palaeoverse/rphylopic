#' @title List images
#' 
#' @description Lists images in chronological order of submission, from most to least recent.
#'
#' @keywords internal
#' @param start The index to start with. Using 0 starts with the most recently-submitted image.
#' @param length The number of images to list.
#' @param options See details for the options for options.
#' @param ... curl options passed on to [crul::HttpClient]
#' @details Here are the options for the options argument:
#' 
#' - citationStart: (optional) Integer Indicates where in the string the citation starts. May be null.
#' - html: (optional) StringHTML version of the name.
#' - namebankID: (optional) StringuBio Namebank identifier. May be null.
#' - root: (optional) Boolean If true, this name has no hyperonyms (names of supertaxa). (Should only be true for Panbiota/Vitae.)
#' - string: (optional) String The text of the name, including the citation, if any.
#' - type: (optional) String Either "scientific or "vernacular.
#' - uid: (always) String Universally unique identifier.
#' - uri: (optional) String The unique URI associated with the name.
#' - votes: (optional) Integer The number of votes this name has received. (Currently unused.)
#'
#' @examples \dontrun{
#' list_images(start=1, length=10)
#' list_images(start=1, length=10, options=c('string','taxa'))
#' list_images(start=500, length=10)
#' }
list_images <- function(start, length, options=NULL, ...) {
  args <- pc(list(options = paste0(options, collapse = " ")))
  path <- file.path('api/a/image/list', start, length)
  phy_GET(path, args, ...)$result
}
