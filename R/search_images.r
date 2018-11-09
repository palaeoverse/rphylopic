#' Search for images for a taxon (via its uuid)
#' 
#' @export
#' @param uuid (character) one or more UUIDs of taxonomic names
#' @param subtaxa If set to `TRUE`, includes subtaxa in the search.
#' @param supertaxa If not set to `FALSE`, includes supertaxa in the search.
#' @param other If set to `TRUE`, includes related taxa in the search.
#' @param options Space-separated list of options for the result value.
#' @param cleanoutput If `TRUE`, remove elements with no data.
#' @param ... curl options passed on to [crul::HttpClient]
#' @examples \dontrun{
#' search_images('1ee65cf3-53db-4a52-9960-a9f7093d845d', 
#'   subtaxa = "true", options = c("pngFiles", "credit", "licenseURL", 
#'   "svgFile", "canonicalName", "html"))
#' 
#' # all of them
#' search_images(c("1ee65cf3-53db-4a52-9960-a9f7093d845d",
#'    "08141cfc-ef1f-4d0e-a061-b1347f5297a0"), 
#'    options=c("pngFiles", "credit", "canonicalName"))
#' }

search_images <- function(uuid, subtaxa = NULL, supertaxa = NULL, other = NULL, 
  options = NULL, cleanoutput = TRUE, ...) {
  
  foo <- function(z, ...){  
    options <- paste0(options, collapse = " ")
    args <- pc(list(subtaxa = subtaxa, supertaxa = supertaxa, 
      other = other, options = options))
    cli <- crul::HttpClient$new(url = pbase(), opts = list(...))
    tt <- cli$get(path = file.path('api/a/name', z, "images"), 
      query = args)
    tt$raise_for_status()
    stopifnot(tt$response_headers$`content-type` == 
      "application/json; charset=utf-8")
    res <- tt$parse("UTF-8")
    out <- jsonlite::fromJSON(res, FALSE)
    
    other <- lenzerotonull(out$result$other)
    supertaxa <- lenzerotonull(out$result$supertaxa)
    subtaxa <- lenzerotonull(out$result$subtaxa)
    same <- lenzerotonull(out$result$same)
    
    pc(list(other = other, supertaxa = supertaxa, 
      subtaxa = subtaxa, same = same))
  }
  temp <- lapply(uuid, foo, ...)
  names(temp) <- uuid
  if (cleanoutput) {
    temp2 <- temp[!sapply(temp, function(x) length(x)) == 0]
    res <- parse_png_info(temp2)
  } else { 
    res <- parse_png_info(temp) 
  }
  structure(res, class = c('image_info', 'data.frame'))
}

lenzerotonull <- function(x) if (length(x) == 0) NULL else x

parse_png_info <- function(x){
  out <- list()
  for (i in seq_along(x)) {
    out[[i]] <- lapply(x[[i]]$same, function(z) {
      tmp <- do.call("rbind", lapply(z$pngFiles, data.frame, 
        stringsAsFactors = FALSE))
      tmp$uuid <- names(x)[i]
      tmp
    })
  }
  do.call("rbind", unlist(out, FALSE))
}
