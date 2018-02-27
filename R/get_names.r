#' Get names for uuids.
#'
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
#' @param ... curl options passed on to [crul::HttpClient]
#' @details Here are the options for the options argument:
#' 
#' - citationStart: (optional) Integer Indicates where in the string the 
#' citation starts. May be null.
#' - html: (optional) StringHTML version of the name.
#' - namebankID: (optional) StringuBio Namebank identifier. May be null.
#' - root: (optional) Boolean If true, this name has no hyperonyms (names of 
#' supertaxa). (Should only be true for Panbiota/Vitae.)
#' - string: (optional) String The text of the name, including the citation, if any.
#' - type: (optional) String Either "scientific or "vernacular.
#' - uid: (always) String Universally unique identifier.
#' - uri: (optional) String The unique URI associated with the name.
#' - votes: (optional) Integer The number of votes this name has received. 
#' (Currently unused.)
#' 
#' @examples \dontrun{
#' get_names(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", options = "string")
#' get_names(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", supertaxa="immediate", 
#'    options=c("string namebankID"))
#' get_names(uuid = "f3254fbd-284f-46c1-ae0f-685549a6a373", supertaxa="all", 
#'    options="string")
#' }

get_names <- function(uuid, supertaxa=NULL, subtaxa=NULL, options=NULL, 
  stripauthority=TRUE, ...) {

  path <- file.path('api/a/name', uuid, "taxonomy")
  if (stripauthority) {
    options <- paste(options, "citationStart", sep = " ")
  }
  args <- as_null(pc(list(supertaxa = supertaxa, subtaxa = subtaxa, 
    options = options)))
  out <- phy_GET(path, args, ...)
  stuff <- out$result$taxa
  stuff2 <- lapply(stuff, replacenull)
  stuff2 <- lapply(stuff2, citationtonumber)

  temp <- do.call("rbind", lapply(stuff2, function(x) 
    data.frame(x$canonicalName, stringsAsFactors = FALSE)))

  if (stripauthority) {
    for (i in 1:NROW(temp)) {
      temp[i, "name"] <- stripauth(temp[i, 'string'], temp[i, 'citationStart'])
    }
  }
  temp$citationStart <- NULL
  temp
}

stripauth <- function(x, y) { 
  if (y != 1) {
    substring(x, 1, y - 1)
  } else { 
    x 
  } 
}
