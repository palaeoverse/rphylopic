#' Perform actions with images.
#'
#' @name image
#' @details I'm not adding methods for modifying images, including add, edit, updated, delete, and
#' transfer, because I can't imagine doing those things from R. Am I wrong?
#'
#' Note: uid is always returned
#' @examples \dontrun{
#' # Get info on an image
#' id <- "9fae30cd-fb59-4a81-a39c-e1826a35f612"
#' image_get(uuid = id)
#' image_get(uuid = id, options=c('credit','pngFiles','taxa','canonicalName','string','uri','type'))
#' image_get(uuid = id, options=c('credit','licenseURL','pngFiles','submitted','submitter',
#'    'svgFile','taxa','canonicalName','string','uri','type','citationStart'))
#'
#' # Count images in Phylopic database
#' image_count()
#' library('httr')
#' image_count(config = verbose())
#'
#' # Lists images in chronological order, from most to least recently modified
#' image_list(start=1, length=10)
#' image_list(start=1, length=10, options="taxa")
#'
#' # Lists images within a given time range, from most to least recent
#' image_timerange(from="2013-05-11")
#' image_timerange(from="2013-05-11", to="2013-05-12")
#' image_timerange(from="2013-05-11", to="2013-05-12", options='credit')
#' }

#' @export
#' @rdname image
image_get <- function(uuid, options=NULL, ...){
  args <- if(!is.null(options)) list(options = paste0(options, collapse = " ")) else list()
  phy_GET(paste0(ibase(), uuid), args, ...)$result
}

#' @export
#' @rdname image
image_list <- function(start=1, length=10, options=NULL, ...){
  args <- if(!is.null(options)) list(options = paste0(options, collapse = " ")) else list()
  phy_GET(sprintf("%s%s/%s/%s", ibase(), "list", start, length), args, ...)$result
}

#' @export
#' @rdname image
image_timerange <- function(timestamp="modified", from=NULL, to=NULL, options=NULL, ...){
  args <- if(!is.null(options)) list(options = paste0(options, collapse = " ")) else list()
  url <- sprintf("%s%s/%s/", ibase(), "list", timestamp)
  url <- paste0(url, from, "/", to)
  phy_GET(url, args, ...)$result
}

#' @export
#' @rdname image
image_count <- function(...){
  content(GET(paste0(ibase(), "count"), ...))$result
}

phy_GET <- function(url, args, ...){
  res <- GET(url, query=args, ...)
  stop_for_status(res)
  jsonlite::fromJSON(content(res, "text"), FALSE)
}

ibase <- function() "http://phylopic.org/api/a/image/"
