#' Text search for uuids
#' 
#' These aren't necessarily ones with images though. See example
#' 
#' @import httr jsonlite
#' @export
#' @param text Search string, see examples
#' @param options See here for options
#' @param ... Further args passed on to GET. See examples.
#' @return A list. You always get back the UUID, and any other fields requested.
#' @examples \dontrun{
#' search_text(text = "Homo sapiens")
#' search_text(text = "Homo sapiens", options = "names")
#' search_text(text = "Homo sapiens", options = "type")
#' search_text(text = "Homo sapiens", options = "namebankID")
#' search_text(text = "Homo sapiens", options = "root")
#' search_text(text = "Homo sapiens", options = "uri")
#' search_text(text = "Homo sapiens", options = c("string","type","uri"))
#' library("httr")
#' search_text(text = "Homo sapiens", options = "names", config=verbose())
#' }

search_text <- function(text, options="string", simplify=TRUE, ...)
{
  url <- "http://phylopic.org/api/a/name/search"
  options <- paste0(options, collapse = " ")
  args <- phy_compact(list(text = text, options = options))
  tt <- GET(url, query=args, ...)
  assert_that(tt$status_code < 203)
  assert_that(tt$headers$`content-type` == "application/json; charset=utf-8")
  res <- content(tt, as = "text")
  out <- fromJSON(res, FALSE)
  if(simplify){
    unname(unlist(do.call(c, sapply(out$result, function(x) x[[1]], simplify=TRUE))))
  } else {
    out$result    
  }
#   do.call(c, sapply(out$result, function(x) x[[1]], simplify=TRUE))
}