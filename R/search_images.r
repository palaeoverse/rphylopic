#' Search for images for the taxa
#' 
#' @import httr jsonlite assertthat
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
  cleanoutput = TRUE, ...)
{  
  url <- "http://phylopic.org/api/a/name/"
  
  foo <- function(inputuuid){  
    url2 <- paste0(url, inputuuid, "/images")
    
    options <- paste0(options, collapse = " ")
    args <- phy_compact(list(subtaxa=subtaxa, options=options))
    tt <- GET(url2, query=args, ...)
    assert_that(tt$status_code < 203)
    assert_that(tt$headers$`content-type` == "application/json; charset=utf-8")
    res <- content(tt, as = "text")
    out <- jsonlite::fromJSON(res, FALSE)
    
    other <- lenzerotonull(out$result$other)
    supertaxa <- lenzerotonull(out$result$supertaxa)
    subtaxa <- lenzerotonull(out$result$subtaxa)
    same <- lenzerotonull(out$result$same)
    
    phy_compact(list(other=other, supertaxa=supertaxa, subtaxa=subtaxa, same=same))
  }
  temp <- lapply(uuid, foo)
  names(temp) <- uuid
  if(cleanoutput){
    temp2 <- temp[!sapply(temp, function(x) length(x))==0]
    res <- parse_png_info(temp2)
  } else { res <- parse_png_info(temp2) }
  class(res) <- c('image_info','data.frame')
  return( res )
}

lenzerotonull <- function(x) if(length(x)==0) NULL else x

parse_png_info <- function(x){
  tmp <- lapply(x, function(z){
    do.call(rbind, lapply(z[[1]][[1]]$pngFiles, data.frame, stringsAsFactors = FALSE))
  })
  tmp2 <- ldply(tmp)
  names(tmp2)[1] <- "uuid"
  tmp2
}
