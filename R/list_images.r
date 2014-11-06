#' Lists images in chronological order of submission, from most to least recent.
#'
#' @import httr jsonlite
#' @export
#' @param start The index to start with. Using 0 starts with the most recently-submitted image.
#' @param length The number of images to list.
#' @param options See details for the options for options.
#' @param ... Further args passed on to GET. See examples.
#' @details Here are the options for the options argument:
#' \itemize{
#'  \item{citationStart}{[optional] Integer Indicates where in the string the citation starts. May be null.}
#'  \item{html}{[optional] StringHTML version of the name.}
#'  \item{namebankID}{[optional] StringuBio Namebank identifier. May be null.}
#'  \item{root}{[optional] Boolean If true, this name has no hyperonyms (names of supertaxa). (Should only be true for Panbiota/Vitae.)}
#'  \item{string}{[optional] String The text of the name, including the citation, if any.}
#'  \item{type}{[optional] String Either "scientific or "vernacular.}
#'  \item{uid}{[always] String Universally unique identifier.}
#'  \item{uri}{[optional] String The unique URI associated with the name.}
#'  \item{votes}{[optional] Integer The number of votes this name has received. (Currently unused.)}
#' }
#' @examples \dontrun{
#' list_images(start=1, length=10)
#' list_images(start=1, length=10, options=c('string','taxa'))
#' list_images(start=500, length=10)
#' }

list_images <- function(start, length, options=NULL, ...)
{
  options <- paste0(options, collapse = " ")
  url <- "http://phylopic.org/api/a/image/list/"
  args <- phy_compact(list(options = options))
  tt <- GET(paste(url,start,"/",length,sep=""), query=args, ...)
  stopifnot(tt$status_code < 203)
  stopifnot(tt$headers$`content-type` == "application/json; charset=utf-8")
  res <- content(tt, as = "text")
  out <- fromJSON(res, FALSE)
  out$result
}
