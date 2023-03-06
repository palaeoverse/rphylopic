#' Retrieve an image for a given UUID.
#' 
#' This retrieves a phylopic silhouette as a vectorized or rasterized object.
#'
#' @param uuid An image UUID.
#' @param format Format of the image. To return a vectorized image, use.
#'   "vector". To return a rasterized image, use one of 512, 1024, or 1536.
#'   Rasterized thumbnails can be returned by using 64, 128, or 192. Finally,
#'   using "twitter" will return a rasterized image that includes the phylopic
#'   logo and is formatted for posting on social media.
#' @export
#' @examples
#' uuid <- "9fae30cd-fb59-4a81-a39c-e1826a35f612"
#'
#' # Get data for an image
#' img_svg <- get_phylopic(uuid, format = "vector") # vector format
#' img_png <- get_phylopic(uuid, format = "512") # raster format
get_phylopic <- function(uuid, format = "vector") {
  format <- match.arg(as.character(format),
                    c("64", "128", "192", "512", "1024", "1536", "twitter",
                      "vector"))
  image_info <- phy_GET(file.path("images", uuid))$`_links`
  if (format %in% c("64", "128", "192")) { # get thumbnail url
    thumbs <- image_info$thumbnailFiles
    url <- thumbs$href[grepl(format, thumbs$sizes)]
  } else if (format %in% c("512", "1024", "1536")) { # get raster url
    rasters <- image_info$rasterFiles
    url <- rasters$href[grepl(format, rasters$sizes)]
  } else if (format == "twitter") { # get twitter url
    url <- image_info$`twitter:image`$href
  } else if (format == "vector") { # get vector url
    url <- image_info$vectorFile$href
  }
  ret <- if (format == "vector") get_svg(url) else get_png(url)
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
