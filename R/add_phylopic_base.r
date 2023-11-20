#' Add PhyloPics to a base R plot
#'
#' Specify existing images, taxonomic names, or PhyloPic uuids to add PhyloPic
#' silhouettes on top of an existing base R plot (like [points()]).
#'
#' @param img A [Picture][grImport2::Picture-class] or png array object, e.g.,
#'   from using [get_phylopic()].
#' @param name \code{character}. A taxonomic name to be passed to [get_uuid()].
#' @param uuid \code{character}. A valid uuid for a PhyloPic silhouette (such as
#'   that returned by [get_uuid()] or [pick_phylopic()]).
#' @param filter \code{character}. Filter by usage license if `name` is defined.
#'   Use "by" to limit results to images which do not require attribution, "nc"
#'   for images which allows commercial usage, and "sa" for images without a
#'   ShareAlike clause. The user can also combine these filters as a vector.
#' @param x \code{numeric}. x value of the silhouette center. Ignored if `y` and
#'   `ysize` are not specified.
#' @param y \code{numeric}. y value of the silhouette center. Ignored if `x` and
#'   `ysize` are not specified.
#' @param ysize \code{numeric}. Height of the silhouette. The width is
#'   determined by the aspect ratio of the original image. Ignored if `x` and
#'   `y` are not specified.
#' @param alpha \code{numeric}. A value between 0 and 1, specifying the opacity
#'   of the silhouette (0 is fully transparent, 1 is fully opaque).
#' @param color \code{character}. Color of silhouette outline. If "original" or
#'   NA is specified, the original color of the silhouette outline will be used
#'   (usually the same as "transparent").
#' @param fill \code{character}. Color of silhouette. If "original" is
#'   specified, the original color of the silhouette will be used (usually the
#'   same as "black"). If `color` is specified and `fill` is NA, `color` will be
#'   used as the fill color (for backwards compatibility).
#' @param horizontal \code{logical}. Should the silhouette be flipped
#'   horizontally?
#' @param vertical \code{logical}. Should the silhouette be flipped vertically?
#' @param angle \code{numeric}. The number of degrees to rotate the silhouette
#'   clockwise. The default is no rotation.
#' @param remove_background \code{logical}. Should any white background be
#'   removed from the silhouette(s)? See [recolor_phylopic()] for details.
#' @param verbose \code{logical}. Should the attribution information for the
#'   used silhouette(s) be printed to the console (see [get_attribution()])?
#' @details One (and only one) of `img`, `name`, or `uuid` must be specified.
#'   Use parameters `x`, `y`, and `ysize` to place the silhouette at a specified
#'   position on the plot. If all three of these parameters are unspecified,
#'   then the silhouette will be plotted to the full height and width of the
#'   plot. The aspect ratio of the silhouette will always be maintained (even
#'   when a plot is resized). However, if the plot is resized after plotting the
#'   silhouette, the absolute size and/or position of the silhouette may change.
#'
#'   Any argument (except for `remove_background`) may be a vector of values if
#'   multiple silhouettes should be plotted. In this case, all other arguments
#'   may also be vectors of values, which will be recycled as necessary to the
#'   length of the longest vector argument.
#'
#'   When specifying a horizontal and/or vertical flip **and** a rotation, the
#'   flip(s) will always occur first. If you would like to customize this
#'   behavior, you can flip and/or rotate the image within your own workflow
#'   using [flip_phylopic()] and [rotate_phylopic()].
#'
#'   Note that png array objects can only be rotated by multiples of 90 degrees.
#'   Also, outline colors do not currently work for png array objects.
#' @importFrom graphics par grconvertX grconvertY
#' @importFrom grid grid.raster
#' @importFrom grImport2 grid.picture
#' @importFrom methods is slotNames
#' @export
#' @examples
#' # single image
#' plot(1, 1, type = "n", main = "A cat")
#' add_phylopic_base(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
#'                   x = 1, y = 1, ysize = 0.4)
#'
#' # lots of images using a uuid
#' posx <- runif(10, 0, 1)
#' posy <- runif(10, 0, 1)
#' size <- runif(10, 0.1, 0.3)
#' angle <- runif(10, 0, 360)
#' hor <- sample(c(TRUE, FALSE), 10, TRUE)
#' ver <- sample(c(TRUE, FALSE), 10, TRUE)
#' fills <- sample(c("black", "darkorange", "grey42", "white"), 10,
#'                replace = TRUE)
#'
#' plot(posx, posy, type = "n", main = "A cat herd")
#' add_phylopic_base(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
#'                   x = posx, y = posy, ysize = size,
#'                   fill = fills, angle = angle,
#'                   horizontal = hor, vertical = ver)
#'
#' # Example using a cat background
#' cat <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
#' # setup plot area
#' plot(posx, posy, type = "n", main = "A cat herd, on top of a cat",
#'      xlim = c(0, 1), ylim = c(0, 1))
#' # plot background cat
#' add_phylopic_base(img = cat, alpha = 0.2)
#' # overlay smaller cats
#' add_phylopic_base(img = cat, x = posx, y = posy, ysize = size, alpha = 0.8)
add_phylopic_base <- function(img = NULL, name = NULL, uuid = NULL,
                              filter = NULL,
                              x = NULL, y = NULL, ysize = NULL,
                              alpha = 1, color = NA, fill = "black",
                              horizontal = FALSE, vertical = FALSE, angle = 0,
                              remove_background = TRUE, verbose = FALSE) {
  if (all(sapply(list(img, name, uuid), is.null))) {
    stop("One of `img`, `name`, or `uuid` is required.")
  }
  if (sum(sapply(list(img, name, uuid), is.null)) < 2) {
    stop("Only one of `img`, `name`, or `uuid` may be specified")
  }
  if (any(alpha > 1 | alpha < 0)) {
    stop("`alpha` must be between 0 and 1.")
  }
  if (!is.logical(verbose)) {
    stop("`verbose` should be a logical value.")
  }

  if (!is.null(name)) {
    if (!is.character(name)) {
      stop("`name` should be of class character.")
    }
    if (!verbose) {
      warning(paste("You've used the `name` argument. You may want to use",
                    "`verbose = TRUE` to get attribution information",
                    "for the silhouette(s)."), call. = FALSE)
    }
    # Get PhyloPic for each unique name
    name_unique <- unique(name)
    imgs <- sapply(name_unique, function(x) {
      id <- tryCatch(get_uuid(name = x, filter = filter),
                     error = function(cond) NA)
      if (is.na(id)) {
        text <- paste0("`name` ", '"', name, '"')
        if (!is.null(filter)) {
          text <- paste0(text, " with `filter` ", '"',
                         paste0(filter, collapse = "/"), '"')
        }
        warning(paste0(text, " returned no PhyloPic results."))
        return(NULL)
      }
      get_phylopic(id)
    })
    imgs <- imgs[name]
  } else if (!is.null(uuid)) {
    if (!is.character(uuid)) {
      stop("`uuid` should be of class character.")
    }
    # Get PhyloPic for each unique uuid
    uuid_unique <- unique(uuid)
    imgs <- sapply(uuid_unique, function(x) {
      img <- tryCatch(get_phylopic(x),
                      error = function(cond) NULL)
      if (is.null(img)) {
        warning(paste0('"', x, '"', " is not a valid PhyloPic `uuid`."))
      }
      img
    })
    imgs <- imgs[uuid]
  } else {
    if (!is.list(img)) img <- list(img)
    if (any(sapply(img, function(x) {
      !is(x, "Picture") && !is.array(x)
    }))) {
      stop(paste("`img` should be of class Picture (for a vector image)",
                 "or class array (for a raster image)."))
    }
    imgs <- img
  }
  if (verbose) {
    get_attribution(img = imgs, text = TRUE)
  }

  # get plot limits
  usr <- par()$usr
  usr_x <- if (par()$xlog) 10^usr[1:2] else usr[1:2]
  usr_y <- if (par()$ylog) 10^usr[3:4] else usr[3:4]

  # set default position and size if need be
  if (is.null(x)) x <- mean(usr_x)
  if (is.null(y)) y <- mean(usr_y)
  if (is.null(ysize)) ysize <- abs(diff(usr_y))

  # convert x, y, and ysize to normalized device coordinates
  x <- grconvertX(x, to = "ndc")
  y <- grconvertY(y, to = "ndc")
  ysize <- grconvertY(ysize, to = "ndc") - grconvertY(0, to = "ndc")

  invisible(mapply(function(img, x, y, ysize, alpha, color, fill,
                            horizontal, vertical, angle) {
    if (is.null(img)) return(NULL)

    if (horizontal || vertical) img <- flip_phylopic(img, horizontal, vertical)
    if (angle != 0) img <- rotate_phylopic(img, angle)

    # recolor if necessary
    if (is.na(color) || color == "original") color <- NULL
    if (is.na(fill)) {
      fill <- color
      color <- NULL
    }
    if (fill == "original") fill <- NULL
    img <- recolor_phylopic(img, alpha, color, fill, remove_background)

    # grobify and plot
    if (is(img, "Picture")) { # svg
      if ("summary" %in% slotNames(img) &&
          all(c("xscale", "yscale") %in% slotNames(img@summary)) &&
          is.numeric(img@summary@xscale) && length(img@summary@xscale) == 2 &&
          all(is.finite(img@summary@xscale)) && diff(img@summary@xscale) != 0 &&
          is.numeric(img@summary@yscale) && length(img@summary@yscale) == 2 &&
          all(is.finite(img@summary@yscale)) && diff(img@summary@yscale) != 0) {
        grid.picture(img, x = x, y = y, height = ysize, expansion = 0)
      } else {
        return(NULL)
      }
    } else { # png
      grid.raster(img, x = x, y = y, height = ysize)
    }
  },
  img = imgs, x = x, y = y, ysize = ysize, alpha = alpha, color = color,
  fill = fill, horizontal = horizontal, vertical = vertical, angle = angle))
}
