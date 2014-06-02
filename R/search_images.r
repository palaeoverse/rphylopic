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
#' search_images(uuid=someuuids, options=c("pngFiles", "credit", "canonicalName"))
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
    out <- fromJSON(res, FALSE)
    
#     other <- as.character(sapply(out$result$other, function(x) x[[1]]))
    other <- lenzerotonull(out$result$other)
#     supertaxa <- as.character(sapply(out$result$supertaxa, function(x) x[[1]]))
    supertaxa <- lenzerotonull(out$result$supertaxa)
#     subtaxa <- as.character(sapply(out$result$subtaxa, function(x) x[[1]]))
    subtaxa <- lenzerotonull(out$result$subtaxa)
    same <- lenzerotonull(out$result$same)
    
    phy_compact(list(other=other, supertaxa=supertaxa, subtaxa=subtaxa, same=same))
  }
  temp <- lapply(uuid, foo)
  names(temp) <- uuid
  if(cleanoutput)
    temp[!sapply(temp, function(x) length(x))==0]
  else
    return( temp )
}

lenzerotonull <- function(x) if(length(x)==0) NULL else x
