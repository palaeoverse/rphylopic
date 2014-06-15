#' Text search for uuids
#' 
#' These aren't necessarily ones with images though. See example
#' 
#' @import httr jsonlite
#' @export
#' @param text (character) Search string, see examples
#' @param options (character) See here for options
#' @param simplify (logical) Simplify result
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
#' search_text(text = "Homo sapiens", options = c("string","type","uri"), simplify=FALSE) 
#' 
#' # pass in curl options
#' library("httr")
#' search_text(text = "Homo sapiens", options = "names", config=verbose())
#' }

search_text <- function(text, options="string", simplify=TRUE, ...)
{
  url <- "http://phylopic.org/api/a/name/search"
  opts <- length(options)
  options <- paste0(options, collapse = " ")
  args <- phy_compact(list(text = text, options = options))
  tt <- GET(url, query=args, ...)
  assert_that(tt$status_code < 203)
  assert_that(tt$headers$`content-type` == "application/json; charset=utf-8")
  res <- content(tt, as = "text")
  out <- fromJSON(res, FALSE)
  if(simplify){
    if(opts == 1){
      if(options %in% c("string","type","namebankID","root")){ 
        opt_length <- "mas" 
      } else if(options %in% "names") {
        opt_length <- "menos"
      }
    } else {
      opt_length <- "mas"
    }
    foo <- function(y){
      tmp <- data.frame(do.call(rbind, lapply(y, function(x) as.character(x[[1]]))), stringsAsFactors = FALSE)
      names(tmp) <- names(y[[1]][[1]])
      tmp
    }
    switch(opt_length, 
           menos = unname(unlist(do.call(c, sapply(out$result, function(x) x[[1]], simplify=TRUE)))),
           mas = foo(out$result))
  } else {
    out$result    
  }
}