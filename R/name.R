#' Perform actions with names.
#'
#' @name name
#' @param uuid One or more name UUIDs.
#' @param options (character) One or more of citationStart, html, namebankID, root, string,
#' type, uid, uri, and/or votes
#' @param subtaxa If immediate, returns data for immediate subtaxa ("children").
#' Otherwise, does not include subtaxa.
#' @param supertaxa If immediate, returns data for immediate supertaxa ("parents").
#' If all, returns data for all supertaxa ("ancestors"). Otherwise, does not
#' include supertaxa.
#' @param other If set to TRUE, includes related taxa in the search.
#' @param text (character) The text string to search on.
#' @param useUBio (logical) If TRUE, and there is pending data from uBio that needs to be cached, 
#' a list of commands will be passed back instead of the normal result.
#' @param as (character) What to return. One of table (default, a data.frame), list, or json.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @details I'm not adding methods for modifying names, including add, edit, or toggle, because
#' I can't imagine doing those things from R. Am I wrong?
#'
#' Options for the \code{options} parameter:
#' \itemize{
#'  \item{citationStart}{[optional] Integer Indicates where in the string the citation starts.
#'  May be null.}
#'  \item{html}{[optional] StringHTML version of the name.}
#'  \item{namebankID}{[optional] StringuBio Namebank identifier. May be null.}
#'  \item{root}{[optional] Boolean If true, this name has no hyperonyms (names of supertaxa).
#'  (Should only be true for Panbiota/Vitae.)}
#'  \item{string}{[optional] String The text of the name, including the citation, if any.}
#'  \item{type}{[optional] String Either "scientific or "vernacular.}
#'  \item{uid}{[always] String Universally unique identifier.}
#'  \item{uri}{[optional] String The unique URI associated with the name.}
#'  \item{votes}{[optional] Integer The number of votes this name has received. (Currently unused.)}
#' }
#' @examples \dontrun{
#' # parse as different outputs
#' name_taxonomy(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", options = "string", as="table")
#' name_taxonomy(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", options = "string", as="list")
#' name_taxonomy(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", options = "string", as="json")
#' 
#' # Get info on a name
#' id <- "1ee65cf3-53db-4a52-9960-a9f7093d845d"
#' name_get(uuid = id)
#' name_get(uuid = id, options=c('citationStart','html'))
#' name_get(uuid = id, options=c('namebankID','root','votes'))
#'
#' # Searches for images for a taxonomic name.
#' name_images(uuid = "1ee65cf3-53db-4a52-9960-a9f7093d845d")
#' name_images(uuid = "1ee65cf3-53db-4a52-9960-a9f7093d845d", options='credit')
#'
#' # Finds the minimal common supertaxa for a list of names.
#' name_minsuptaxa(uuid=c("1ee65cf3-53db-4a52-9960-a9f7093d845d",
#'    "08141cfc-ef1f-4d0e-a061-b1347f5297a0"))
#'
#' # Finds the taxa whose names match a piece of text.
#' name_search(text = "Homo sapiens")
#' name_search(text = "Homo sapiens", options = "names")
#' name_search(text = "Homo sapiens", options = "type")
#' name_search(text = "Homo sapiens", options = "namebankID")
#' name_search(text = "Homo sapiens", options = "root")
#' name_search(text = "Homo sapiens", options = "uri")
#' name_search(text = "Homo sapiens", options = c("string","type","uri"))
#'
#' # Collects taxonomic data for a name.
#' name_taxonomy(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", options = "string")
#' name_taxonomy(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", supertaxa="immediate",
#'    options=c("string","namebankID"))
#' name_taxonomy(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", supertaxa="all", options="string")
#' name_taxonomy(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", supertaxa="all", 
#'    options=c("string","uri"))
#' 
#' # Collects taxonomic data for multiple names.
#' name_taxonomy_many(uuid = c("f3254fbd-284f-46c1-ae0f-685549a6a373", 
#'  "1ee65cf3-53db-4a52-9960-a9f7093d845d"))
#' 
#' # Collects data about the sources for a name's taxonomy.
#' name_taxonomy_sources(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373")
#' name_taxonomy_sources(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", as="json")
#' name_taxonomy_sources(uuid = "1ee65cf3-53db-4a52-9960-a9f7093d845d")
#' }

#' @export
#' @rdname name
name_get <- function(uuid, options=NULL, ...) phy_GET(paste0(nbase(), uuid), collops(options), ...)$result

#' @export
#' @rdname name
name_images <- function(uuid, subtaxa=NULL, supertaxa=NULL, other=FALSE, options=NULL, ...){
  args <- pc(c(collops(options), subtaxa=subtaxa, supertaxa=supertaxa, other=other))
  phy_GET(sprintf("%s%s/%s", nbase(), uuid, "images"), args, ...)$result
}

#' @export
#' @rdname name
name_minsuptaxa <- function(uuid, options=NULL, ...){
  args <- c(collops(options), nameUIDs=paste(uuid, collapse=" "))
  phy_GET(paste0(nbase(), 'minSupertaxa'), args, ...)$result
}

#' @export
#' @rdname name
name_search <- function(text, options=NULL, as="table", ...){
  args <- c(collops(options), text=text)
  res <- phy_GET2(paste0(nbase(), 'search'), args, ...)
  mswitch(as, res)
}

#' @export
#' @rdname name
name_taxonomy <- function(uuid, subtaxa=NULL, supertaxa=NULL, useUBio=FALSE, options=NULL, 
  as="table", ...)
{
  args <- c(collops(options), subtaxa=subtaxa, supertaxa=supertaxa, useUBio=useUBio)
  res <- phy_GET2(paste0(nbase(), uuid, '/taxonomy'), args, ...)
  mswitch(as, res)
}

#' @export
#' @rdname name
name_taxonomy_many <- function(uuid, options=NULL, as="table", ...){
  res <- phy_GET2(paste0(nbase(), 'taxonomy/multiple'), c(collops(options), nameUIDs=paste0(uuid, collapse = " ")), ...)
  mswitch(as, res)
}

#' @export
#' @rdname name
name_taxonomy_sources <- function(uuid, options=NULL, as="list", ...){
  res <- phy_GET2(paste0(nbase(), uuid, '/taxonomy/sources'), collops(options), ...)
  mswitch2(as, res)
}

nbase <- function() "http://phylopic.org/api/a/name/"

collops <- function(x) if(!is.null(x)) list(options = paste0(x, collapse = " ")) else list()

name_parse <- function(x){
  x <- lapply(x, replacenull)
  ldply(x, function(x) data.frame(x[[1]]))
}

mswitch <- function(x, y){
  x <- match.arg(x, c("table","list","json"))
  switch(x, 
         json = y, 
         list = jsonlite::fromJSON(y, FALSE)$result, 
         table = name_parse(jsonlite::fromJSON(y, FALSE)$result)
  )
}

mswitch2 <- function(x, y){
  x <- match.arg(x, c("list", "json"))
  switch(x, json = y, list = jsonlite::fromJSON(y, FALSE)$result)
}
