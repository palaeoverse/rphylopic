#' Search for images for the taxa
#' 
#' @import httr plyr
#' @param uuid The UUID of the taxonomic name.
#' @param subtaxa If set to "true", includes subtaxa in the search.
#' @param supertaxa If not set to "false", includes supertaxa in the search.
#' @param options Space-separated list of options for the result value.
#' @param cleanoutput If TRUE, remove elements with no data.
#' @examples \dontrun{
#' someuuids <- search_text(text = "Homo sapiens", options = "names")
#' search_images(uuid=someuuids[[12]], options=c("pngFiles", "credit", "canonicalName"))
#' 
#' # all of them
#' search_images(uuid=someuuids, options=c("pngFiles", "credit", "canonicalName"))
#' }
#' @export
search_images <- function(uuid, subtaxa = NULL, options = NULL, cleanoutput = TRUE)
{  
  url <- "http://phylopic.org/api/a/name/"
  
  foo <- function(inputuuid){  
    url2 <- paste0(url, inputuuid, "/images")
    
    args <- compact(list(subtaxa=subtaxa, options=options))
    output <- content(GET(url2, query=args))
    
    other <- as.character(sapply(output$result$other, function(x) x[[1]]))
    if(length(other)==0) other <- NULL
    supertaxa <- as.character(sapply(output$result$supertaxa, function(x) x[[1]]))
    if(length(supertaxa)==0) supertaxa <- NULL
    subtaxa <- as.character(sapply(output$result$subtaxa, function(x) x[[1]]))
    if(length(subtaxa)==0) subtaxa <- NULL
    
    compact(list(other=other, supertaxa=supertaxa, subtaxa=subtaxa))
  }
  temp <- llply(uuid, foo)
  names(temp) <- uuid
  if(cleanoutput)
    temp[!sapply(temp, function(x) length(x))==0]
  else
    return( temp )
}