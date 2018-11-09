#' Text search for uuids
#' 
#' @export
#' @param text (character) Search string, see examples
#' @param options (character) See here for options
#' @param simplify (logical) Simplify result
#' @param ... curl options passed on to [crul::HttpClient]
#' @return A list. You always get back the UUID, and any other 
#' fields requested.
#' @details These aren't necessarily ones with images though. 
#' See examples
#' @examples \dontrun{
#' search_text(text = "Homo sapiens")
#' search_text(text = "Homo sapiens", options = "names")
#' search_text(text = "Homo sapiens", options = "type")
#' search_text(text = "Homo sapiens", options = "namebankID")
#' search_text(text = "Homo sapiens", options = "root")
#' search_text(text = "Homo sapiens", options = "uri")
#' search_text(text = "Homo sapiens", options = c("string","type","uri"))
#' search_text(text = "Homo sapiens", options = c("string","type","uri"), 
#'   simplify=FALSE) 
#' 
#' # pass in curl options
#' search_text(text = "Homo sapiens", options = "names", verbose = TRUE)
#' }
search_text <- function(text, options="string", simplify=TRUE, ...) {
  
  opts <- length(options)
  options <- paste0(options, collapse = " ")
  args <- pc(list(text = text, options = options))

  cli <- crul::HttpClient$new(url = pbase(), opts = list(...))
  tt <- cli$get(path = 'api/a/name/search', query = args)
  tt$raise_for_status()
  stopifnot(tt$response_headers$`content-type` == 
    "application/json; charset=utf-8")
  res <- tt$parse("UTF-8")

  out <- jsonlite::fromJSON(res, FALSE)
  if (simplify) {
    if (opts == 1) {
      if (options %in% c("string","type","namebankID","root")) {
        opt_length <- "mas" 
      } else if (options %in% "names") {
        opt_length <- "menos"
      } else if (options %in% "uri") {
        opt_length <- "mas"
      }
    } else {
      opt_length <- "mas"
    }
    foo <- function(y){
      tmp <- data.frame(do.call(rbind, 
        lapply(y, function(x) as.character(x[[1]]))), 
        stringsAsFactors = FALSE)
      names(tmp) <- names(y[[1]][[1]])
      tmp
    }
    switch(opt_length, 
           menos = unname(unlist(do.call(c, 
            sapply(out$result, function(x) x[[1]], simplify = TRUE)))),
           mas = foo(out$result))
  } else {
    out$result    
  }
}
