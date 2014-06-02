#' Text search for uuids
#' 
#' These aren't necessarily ones with images though. See example
#' 
#' @import httr RJSONIO plyr
#' @export
#' @param text Search string, see examples
#' @param options See here for options
#' @examples \dontrun{
#' search_text(text = "Homo sapiens", options = "names")
#' }

search_text <- function(text, options)
{
  url <- "http://phylopic.org/api/a/name/search"
  args <- compact(list(text = text, options = options))
  output <- content(GET(url, query=args), as="text")
  stuff <- RJSONIO::fromJSON(output)$result
  uuids <- as.character(do.call(c, sapply(stuff, function(x) x[[1]], simplify=TRUE)))
  return( uuids )  
}