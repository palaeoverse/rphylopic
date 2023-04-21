#' Retrieve an image for a given PhyloPic uuid
#'
#' This retrieves a PhyloPic silhouette as a vectorized or rasterized object.
#'
#' @param uuid \code{character}. A PhyloPic image uuid.
#' @param format \code{character}. Format of the image. To return a vectorized
#'   image, use "vector". To return a rasterized image, use "raster" and specify
#'   a desired `height`. Rasterized square thumbnails can be returned by using
#'   "64", "128", or "192". Finally, using "twitter" will return a rasterized
#'   image that includes the PhyloPic logo and is formatted for posting on
#'   social media.
#' @param height \code{numeric}. If `format` is "raster", this is the desired
#'   height of the raster image. This is ignored for all other `format`s.
#' @return If `format` is "vector", a [Picture][grImport2::Picture-class] object
#'   is returned. Otherwise, a png array representing the rasterized image is
#'   returned. Either way, the uuid and download url are included as the "uuid"
#'   and "url" attributes, respectively.
#' @importFrom rsvg rsvg_png
#' @importFrom png readPNG
#' @export
#' @examples
#' # uuid
#' uuid <- "9fae30cd-fb59-4a81-a39c-e1826a35f612"
#'
#' # Get data for an image
#' img_svg <- get_phylopic(uuid, format = "vector") # vector format
#' img_png <- get_phylopic(uuid, format = "raster") # raster format
get_phylopic <- function(uuid = NULL, format = "vector", height = 512) {
  # Error handling -------------------------------------------------------
  if (is.null(uuid)) {
    stop("A `uuid` is required (hint: use `get_uuid()`).")
  }
  if (length(uuid) > 1) {
    stop("The length of `uuid` is more than one. Use `sapply()`.")
  }
  if (!is.character(uuid)) {
    stop("`uuid` is not of class character.")
  }
  if (as.character(format) %in% c("512", "1024", "1536")) {
    lifecycle::deprecate_warn("1.1.0",
                              paste0("get_phylopic(format = '",
                                     "no longer supports values of ",
                                     "512, 1024, or 1536')"),
                              details = paste0("Use the `height` argument ",
                                               "instead with the `format` ",
                                               "argument set to \"raster\"."))
    height <- as.numeric(format)
    format <- "raster"
  }
  format <- match.arg(as.character(format),
                      c("64", "128", "192", "raster", "twitter", "vector"))
  image_info <- phy_GET(file.path("images", uuid))$`_links`
  ret <- NULL
  if (format %in% c("64", "128", "192")) { # get thumbnail url
    thumbs <- image_info$thumbnailFiles
    ind <- grepl(format, thumbs$sizes)
    if (!any(ind)) {
      ind <- 1
      warning(paste("No thumbnail image with dimension", format, "available.",
                    "Returning thumbnail image with dimensions",
                    rasters$sizes[1], "instead."))
    }
    url <- thumbs$href[ind]
  } else if (format == "raster") {
    rasters <- image_info$rasterFiles
    # check if there is an existing file with the desired height
    ind <- grepl(paste0("x", height), rasters$sizes)
    if (any(ind)) {
      url <- rasters$href[ind]
    } else {
      # use the svg to make a png with the desired height
      ret <- readPNG(rsvg_png(image_info$vectorFile$href, height = height))
      url <- image_info$vectorFile$href
    }
  } else if (format == "twitter") { # get twitter url
    url <- image_info$`twitter:image`$href
  } else if (format == "vector") { # get vector url
    url <- image_info$vectorFile$href
  }
  if (is.null(ret)) {
    ret <- if (format == "vector") get_svg(url) else get_png(url)
  }
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
    img_new <- ga_to_rgba(img_tmp)
  } else {
    img_new <- img_tmp
  }
  img_new
}
