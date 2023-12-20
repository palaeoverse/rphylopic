#' Retrieve an image for a given PhyloPic uuid
#'
#' This retrieves a PhyloPic silhouette as a vectorized or rasterized object.
#'
#' @details The `height` argument is ignored if the `format` argument is not set
#'   to "raster". If `format` is "raster", the `height` argument specifies the
#'   height of the desired raster object. The width of this raster object will
#'   be determined by the original aspect ratio of the silhouette. If a
#'   pre-rendered raster exists with the desired dimensions, it will be
#'   downloaded from PhyloPic. If not, the vector image from PhyloPic will be
#'   used to render a raster object of the desired size.
#'
#' @param uuid \code{character}. A PhyloPic image uuid.
#' @param format \code{character}. Format of the image. To return a vectorized
#'   image, use "vector". To return a rasterized image, use "raster" and specify
#'   a desired `height`.
#' @param height \code{numeric}. If `format` is "raster", this is the desired
#'   height of the raster image in pixels. This is ignored if `format` is
#'   "vector".
#' @param preview \code{logical}. If `preview` is `TRUE`, the returned
#'   image is plotted. Defaults to `FALSE`.
#' @return If `format` is "vector", a [Picture][grImport2::Picture-class] object
#'   is returned. If `format` is "raster", a png array representing the
#'   rasterized image is returned. Either way, the uuid and download url are
#'   included as the "uuid" and "url" attributes, respectively.
#' @importFrom grid grid.newpage grid.raster
#' @importFrom grImport2 grid.picture
#' @export
#' @examples \dontrun{
#' # uuid
#' uuid <- "9fae30cd-fb59-4a81-a39c-e1826a35f612"
#'
#' # Get data for an image
#' img_svg <- get_phylopic(uuid, format = "vector") # vector format
#' img_png <- get_phylopic(uuid, format = "raster") # raster format
#' }
get_phylopic <- function(uuid = NULL, format = "vector", height = 512,
                         preview = FALSE) {
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
  if (!is.logical(preview)) {
    stop("`preview` is not of class logical.")
  }
  if (is.numeric(format) || grepl("^[[:digit:]]+$", as.character(format))) {
    lifecycle::deprecate_warn("1.1.0",
                              paste0("get_phylopic(format = '",
                                     "no longer supports numeric values')"),
                              details = paste0("Use the `height` argument ",
                                               "instead with the `format` ",
                                               "argument set to \"raster\"."))
    height <- as.numeric(format)
    format <- "raster"
  }
  format <- match.arg(as.character(format), c("raster", "vector"))
  image_info <- phy_GET(file.path("images", uuid))$`_links`
  if (format == "raster") { # get raster
    rasters <- image_info$rasterFiles
    # check if there is an existing file with the desired height
    ind <- grepl(paste0("x", height), rasters$sizes)
    if (any(ind)) {
      url <- rasters$href[ind]
      img <- get_png(url)
    } else {
      url <- image_info$vectorFile$href
      # use the svg to make a png with the desired height
      img <- make_png(url, height)
    }
    class(img) <- c("phylopic", class(img))
  } else if (format == "vector") { # get vector
    url <- image_info$vectorFile$href
    img <- get_svg(url)
  }
  # Should the image be previewed?
  if (preview) {
    plot(img)
  }

  attr(img, "uuid") <- uuid
  attr(img, "url") <- url
  img
}

#' @importFrom httr GET
#' @importFrom rsvg rsvg_svg
#' @importFrom grImport2 readPicture
get_svg <- function(url) {
  tryCatch({
    res <- GET(url = url)
    filename <- file.path(tempdir(), "temp.svg")
    rsvg_svg(res$content, filename)
    img_new <- readPicture(filename, warn = FALSE)
  }, error = function(e) {
    stop("Problem downloading vector file. Please try again.")
  })
  img_new
}

#' @importFrom httr GET
#' @importFrom png readPNG
get_png <- function(x) {
  tryCatch({
    res <- GET(url = x)
    img_tmp <- readPNG(res$content)
    # convert to RGBA if in GA format
    if (dim(img_tmp)[3] == 2) {
      img_new <- ga_to_rgba(img_tmp)
    } else {
      img_new <- img_tmp
    }
  },
  error = function(e) {
    stop("Problem downloading raster file. Please try again.")
  })
  img_new
}

#' @importFrom rsvg rsvg_png
#' @importFrom png readPNG
make_png <- function(url, height) {
  tryCatch({
    img_new <- readPNG(rsvg_png(url, height = height))
  },
  error = function(e) {
    stop("Problem downloading vector file. Please try again.")
  })
  img_new
}
