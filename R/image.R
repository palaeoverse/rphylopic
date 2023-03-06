#' Perform actions with images.
#'
#' @name image
#' @param uuid One or more name UUIDs.
#' @param size Height of the image, one of 64, 128, 256, 512, 1024, "thumb", or
#'   "icon"
#' @details I'm not adding methods for modifying images, including add, edit,
#'   updated, delete, and transfer, because I can't imagine doing those things
#'   from R. Am I wrong?
#'
#'   Note: uid is always returned
#' @examples \dontrun{
#' # Get info on an image
#' uuid <- "9fae30cd-fb59-4a81-a39c-e1826a35f612"
#' image_get(uuid = uuid)
#'
#' # Count images in Phylopic database
#' image_count()
#'
#' # Lists images in chronological order, from most to least recently modified
#' image_list()
#' image_list(page = 10)
#'
#' # Return the timerange of images in phylopic
#' image_timerange()
#'
#' # Get data for an image
#' get_phylopic(uuid, size = "vector") # vector format
#' get_phylopic(uuid, size = "512") # raster format
#' }
#' @export
get_phylopic <- function(uuid, size = "vector") {
  size <- match.arg(as.character(size),
    c("64", "128", "192", "512", "1024", "1536", "twitter", "vector", "source"))
  image_info <- phy_GET(file.path("images", uuid))$`_links`
  if (size %in% c("64", "128", "192")) { # get thumbnail url
    thumbs <- image_info$thumbnailFiles
    url <- thumbs$href[grepl(size, thumbs$sizes)]
  } else if (size %in% c("512", "1024", "1536")) { # get raster url
    rasters <- image_info$rasterFiles
    url <- rasters$href[grepl(size, rasters$sizes)]
  } else if (size == "twitter") { # get twitter url
    url <- image_info$`twitter:image`$href
  } else if (size == "vector") { # get vector url
    url <- image_info$vectorFile$href
  } else { # get source url
    url <- image_info$sourceFile$href
  }
  ret <- if (size == "vector") get_svg(url) else get_png(url)
  attr(ret, "uuid") <- uuid
  attr(ret, "url") <- url
  ret
}

#' @importFrom httr GET
#' @importFrom rsvg rsvg_svg
#' @importFrom grImport2 readPicture
get_svg <- function(url) {
  res <- GET(url = url)
  filename <- file.path(tempdir(), "temp.svg")
  rsvg_svg(res$content, filename)
  readPicture(filename)
}

#' @importFrom httr GET
#' @importFrom png readPNG
get_png <- function(x) {
  res <- GET(url = x)
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
