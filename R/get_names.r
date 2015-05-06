#' Get names for uuids.
#'
#' @import httr plyr stringr
#' @export
#' @param uuid UUID to get names for
#' @param subtaxa If immediate, returns data for immediate subtaxa ("children").
#'    Otherwise, does not include subtaxa.
#' @param supertaxa If immediate, returns data for immediate supertaxa ("parents").
#'    If all, returns data for all supertaxa ("ancestors"). Otherwise, does not
#'    include supertaxa.
#' @param options See details for the options for options, get it, ha.
#' @param stripauthority If TRUE (default) the authority is stripped off of the
#'    scientific name.
#' @param ... Further args passed on to GET. See examples.
#' @details Here are the options for the options argument:
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
#' get_names(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", options = "string")
#' get_names(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", supertaxa="immediate", 
#'    options=c("string namebankID"))
#' get_names(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", supertaxa="all", options="string")
#' }

get_names <- function(uuid, supertaxa=NULL, subtaxa=NULL, options=NULL, stripauthority=TRUE, ...)
{
  url <- "http://phylopic.org/api/a/name/"
  url2 <- paste(url, uuid, "/taxonomy", sep="")
  if(stripauthority)
    options <- paste(options, "citationStart", sep=" ")
  args <- pc(list(supertaxa=supertaxa, subtaxa=subtaxa, options=options))
  tt <- GET(url2, query=args, ...)
  stopifnot(tt$status_code < 203)
  stopifnot(tt$headers$`content-type` == "application/json; charset=utf-8")
  res <- content(tt, as = "text")
  out <- fromJSON(res, FALSE)
  stuff <- out$result$taxa
  stuff2 <- llply(stuff, replacenull)
  stuff2 <- llply(stuff2, citationtonumber)

  temp <- ldply(stuff2, function(x) data.frame(x$canonicalName))

  stripauth <- function(x,y){ if(!y==1){ str_sub(x, 1, y-1) } else { x } }

  if(stripauthority){
    temp$rows <- 1:nrow(temp)
    temp <- ddply(temp, .(rows), transform, name = stripauth(string, citationStart))
  }

  return( temp[,!names(temp) %in% c("citationStart","rows")] )
}
