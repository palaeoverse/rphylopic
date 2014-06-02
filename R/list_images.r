#' Lists images in chronological order of submission, from most to least recent.
#'
#' @param start The index to start with. Using 0 starts with the most recently-submitted image.
#' @param length The number of images to list.
#' @param options See details for the options for options.
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
#' }
#' @export
list_images <- function(start, length, options=NULL){
  if(!is.null(options))
    stop("Options aren't implemented yet, sorry...or send a pull request to fix this!")
  url = "http://phylopic.org/api/a/image/list/"
  rphylopic:::unnest(content(GET(paste(url,start,"/",length,sep="")))$result)[[1]]
}
