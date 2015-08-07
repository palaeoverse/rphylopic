#' Search for images for a taxon (via its uuid)
#' 
#' @export
#' @param uuid The UUID of the taxonomic name.
#' @param subtaxa If set to "true", includes subtaxa in the search.
#' @param supertaxa If not set to "false", includes supertaxa in the search.
#' @param options Space-separated list of options for the result value.
#' @param cleanoutput If TRUE, remove elements with no data.
#' @param ... Further args passed on to GET. See examples. 
#' @examples \dontrun{
#' someuuids <- search_text(text = "Homo sapiens", options = "names")
#' search_images(uuid=someuuids[[4]], options=c("pngFiles", "credit", "canonicalName"))
#' 
#' # all of them
#' search_images(uuid=someuuids[1:5], options=c("pngFiles", "credit", "canonicalName"))
#' }

search_images <- function(uuid, subtaxa = NULL, supertaxa = NULL, options = NULL, 
  cleanoutput = TRUE, ...) {
  
  url <- "http://phylopic.org/api/a/name/"
  
  foo <- function(inputuuid){  
    url2 <- paste0(url, inputuuid, "/images")
    
    options <- paste0(options, collapse = " ")
    args <- pc(list(subtaxa = subtaxa, options = options))
    tt <- GET(url2, query = args, ...)
    stopifnot(tt$status_code < 203)
    stopifnot(tt$headers$`content-type` == "application/json; charset=utf-8")
    res <- content(tt, as = "text")
    out <- jsonlite::fromJSON(res, FALSE)
    
    other <- lenzerotonull(out$result$other)
    supertaxa <- lenzerotonull(out$result$supertaxa)
    subtaxa <- lenzerotonull(out$result$subtaxa)
    same <- lenzerotonull(out$result$same)
    
    pc(list(other = other, supertaxa = supertaxa, subtaxa = subtaxa, same = same))
  }
  temp <- lapply(uuid, foo)
  names(temp) <- uuid
  if (cleanoutput) {
    temp2 <- temp[!sapply(temp, function(x) length(x)) == 0]
    res <- parse_png_info(temp2)
  } else { 
    res <- parse_png_info(temp2) 
  }
  structure(res, class = c('image_info','data.frame'))
}

lenzerotonull <- function(x) if (length(x) == 0) NULL else x

parse_png_info <- function(x){
  out <- list()
  for (i in seq_along(x)) {
    out[[i]] <- lapply(x[[i]]$same, function(z) {
      tmp <- do.call("rbind", lapply(z$pngFiles, data.frame, stringsAsFactors = FALSE))
      tmp$uuid <- names(x)[i]
      tmp
    })
  }
  do.call("rbind", unlist(out, FALSE))
}
