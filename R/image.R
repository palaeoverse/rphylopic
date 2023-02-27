#' Perform actions with images.
#'
#' @name image
#' @param uuid One or more name UUIDs.
#' @param options (character) One or more of citationStart, html, namebankID, root, string,
#' type, uid, uri, and/or votes.
#' @param page The page of the results to return.
#' @param ... curl options passed on to [crul::HttpClient]
#' @param size Height of the image, one of 64, 128, 256, 512, 1024, "thumb", or "icon"
#' @details I'm not adding methods for modifying images, including add, edit, updated, delete, and
#' transfer, because I can't imagine doing those things from R. Am I wrong?
#'
#' Note: uid is always returned
#' @examples \dontrun{
#' # Get info on an image
#' uuid <- "9fae30cd-fb59-4a81-a39c-e1826a35f612"
#' image_get(uuid = uuid)
#' image_get(uuid = uuid, options=c('credit','pngFiles','taxa','canonicalName','string','uri','type'))
#' image_get(uuid = uuid, options=c('credit','licenseURL','pngFiles','submitted','submitter',
#'    'svgFile','taxa','canonicalName','string','uri','type','citationStart'))
#'
#' # Count images in Phylopic database
#' image_count()
#' image_count(verbose = TRUE)
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
#' x <- search_text(text = "Homo sapiens", options = "names")
#' output <- search_images(x[1:10], options=c("pngFiles", "credit", "canonicalName"))
#' image_data(output, size = "64")
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
image_get <- function(uuid, options = NULL, ...) {
  phy_GET(file.path("images", uuid), query = options, ...)
}

#' @export
#' @rdname image
image_list <- function(page = 0, options = NULL, ...) {
  phy_GET("images", query = c(list(page = page), options), ...)$`_links`$items
}

#' @export
#' @rdname image
image_timerange <- function(options = NULL, ...) {
  # get total number of pages for query
  tot_pages <- phy_GET("images", query = options, ...)$totalPages
  # get first page
  young_age <- phy_GET("images", query = c(list(page = 0, embed_items = "true"), options), ...)$`_embedded`$items[[1]]$created
  # get last page
  items <- phy_GET("images", query = c(list(page = tot_pages - 1, embed_items = "true"), options), ...)$`_embedded`$items
  old_age <- items[[length(items)]]$created
  list(young_age, old_age)
}

#' @export
#' @rdname image
image_count <- function(options = NULL, ...) {
  phy_GET("images", query = options, ...)$totalItems
}

#' @export
#' @rdname image
image_data <- function(uuid, size = "vector", ...) {
  size <- match.arg(as.character(size), 
    c("64", "128", "192", "512", "1024", "1536", "twitter", "vector", "source"))
  image_info <- phy_GET(file.path("images", uuid), ...)$`_links`
  if (size %in% c("64", "128", "192")) { # get thumbnail url
    thumbs <- image_info$thumbnailFiles
    url <- Filter(function(x) grepl(size, x$sizes), thumbs)[[1]]$href
  } else if (size %in% c("512", "1024", "1536")) { # get raster url
    rasters <- image_info$rasterFiles
    url <- Filter(function(x) grepl(size, x$sizes), rasters)[[1]]$href
  } else if (size == "twitter") { # get twitter url
    url <- image_info$`twitter:image`$href
  } else if (size == "vector") { # get vector url
    url <- image_info$vectorFile$href
  } else { # get source url
    url <- image_info$sourceFile$href
  }
  ret <- if (size == "vector") get_svg(url, ...) else get_png(url, ...)
  attr(ret, "uuid") <- uuid
  attr(ret, "url") <- url
  ret
}

#' @importFrom httr GET
#' @importFrom rsvg rsvg_svg
#' @importFrom grImport2 readPicture
get_svg <- function(url, ...) {
  res <- GET(url = url, config = list(...))
  filename <- file.path(tempdir(), "temp.svg")
  rsvg_svg(res$content, filename)
  readPicture(filename)
}

#' @importFrom httr GET
#' @importFrom png readPNG
get_png <- function(x, ...) {
  res <- GET(url = x, config = list(...))
  img_tmp <- readPNG(res$content)
  # convert to RGBA if in GA format
  if (dim(img_tmp)[3] == 2) {
    img_new <- array(1, dim = c(dim(img_tmp)[1:2], 4))
    img_new[, , 1:3] <- 0
    img_new[, , 4] <- img_tmp[, , 2]
  } else {
    img_new <- img_tmp
  }
  img_new
}
