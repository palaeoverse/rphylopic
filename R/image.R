#' Perform actions with images.
#'
#' @name image
#' @param uuid One or more name UUIDs.
#' @param options (character) One or more of citationStart, html, namebankID, root, string,
#' type, uid, uri, and/or votes
#' @param timestamp Either \code{modified} (to go by the last time the image file was modified) 
#' or \code{submitted} (to go by the time the image was first submitted).
#' @param from  timestamp string, in "YYYY-MM-DD-HH-MM-SS" format, telling the earliest time to 
#' retrieve images for. All numbers past the year are optional. For example, these are 
#' acceptable: "2011-10-29-20-30", "2011-10-29-20", "2011-10-29", "2011-10", and "2011". 
#' Omitted numbers indicate the lowest possible value for that number, for example, "2011" 
#' indicates "2011-01-01-00-00-00" (2011 January 1, midnight). Numbers in the string do not 
#' need to be padded. For example, this is acceptable: "2011-1-1-0-0-0". The image list will 
#' include any images dated at the indicated time. 
#' @param to A date-time string, in "YYYY-MM-DD-HH-MM-SS" format, telling the earliest time to 
#' retrieve images for. See the from parameter for more details on the format. The image list 
#' will include any images dated up to, but not including, the indicated time. 
#' @param start The index to start with. Using 0 starts with the most recently-submitted image.
#' @param length Number of images to list.
#' @param ... Curl options passed on to \code{\link[httr]{GET}}
#' @param input Either a vector of uuids or the output from the function \code{search_images}
#' @param size Height of the image, one of 64, 128, 256, 512, 1024, "thumb", or "icon"
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
#' 
#' # Get data for an image
#' ## input uuids
#' toget <- c("c089caae-43ef-4e4e-bf26-973dd4cb65c5", "41b127f6-0824-4594-a941-5ff571f32378", 
#'    "9c6af553-390c-4bdd-baeb-6992cbc540b1")
#' image_data(toget, size = "64")
#' image_data(toget, size = "thumb")
#' 
#' ## input the output from search_images
#' searchres <- search_text(text = "Homo sapiens", options = "names")
#' output <- search_images(uuid=searchres, options=c("pngFiles", "credit", "canonicalName"))
#' image_data(output, size = "icon")
#'
#' ## Put a silhouette behind a plot
#' library('ggplot2')
#' img <- image_data("27356f15-3cf8-47e8-ab41-71c6260b2724", size = "512")[[1]]
#' qplot(x=Sepal.Length, y=Sepal.Width, data=iris, geom="point") + add_phylopic(img)
#' 
#' ## Use as points in a ggplot plot
#' library('ggplot2')
#' uuid <- "c089caae-43ef-4e4e-bf26-973dd4cb65c5"
#' img <- image_data(uuid, size = "64")[[1]]
#' (p <- ggplot(mtcars, aes(drat, wt)) + geom_blank())
#' for(i in 1:nrow(mtcars)) p <- p + add_phylopic(img, 1, mtcars$drat[i], mtcars$wt[i], ysize = 0.3)
#' p
#' }

#' @export
#' @rdname image
image_get <- function(uuid, options=NULL, ...) {
  args <- if (!is.null(options)) list(options = paste0(options, collapse = " ")) else list()
  phy_GET(paste0(ibase(), uuid), args, ...)$result
}

#' @export
#' @rdname image
image_list <- function(start=1, length=10, options=NULL, ...) {
  args <- if (!is.null(options)) list(options = paste0(options, collapse = " ")) else list()
  phy_GET(sprintf("%s%s/%s/%s", ibase(), "list", start, length), args, ...)$result
}

#' @export
#' @rdname image
image_timerange <- function(timestamp="modified", from=NULL, to=NULL, options=NULL, ...) {
  args <- if (!is.null(options)) list(options = paste0(options, collapse = " ")) else list()
  url <- sprintf("%s%s/%s/", ibase(), "list", timestamp)
  url <- paste0(url, from, "/", to)
  phy_GET(url, args, ...)$result
}

#' @export
#' @rdname image
image_count <- function(...) {
  content(GET(paste0(ibase(), "count"), ...))$result
}

#' @export
#' @rdname image
image_data <- function(input, size) {
  size <- match.arg(as.character(size), c("64", "128", "256", "512", "1024", "thumb", "icon"))
  if (is(input, "image_info")) {
    if (!size %in% c('thumb','icon')) {
      urls <- input[ as.character(input$height) == size , "url" ]
      urls <- sapply(urls, function(x) file.path("http://phylopic.org", x), USE.NAMES = FALSE)
    } else {
      tmp <- vapply(split(input, input$uuid), function(x) x$url[1], "", USE.NAMES = FALSE)
      urls <- paste0(gsub("\\.64\\.png", "", tmp), sprintf(".%s.png", size))
      urls <- sapply(urls, function(x) file.path("http://phylopic.org", x), USE.NAMES = FALSE)
    }
    lapply(urls, getpng)
  } else {
    lapply(input, function(x) getpng(paste0("http://phylopic.org/assets/images/submissions/", x, ".", size, ".png")))
  }
}

getpng <- function(x) {
  tmp <- GET(x)
  stop_for_status(tmp)
  content(tmp)
}
