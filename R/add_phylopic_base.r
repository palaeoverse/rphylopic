#' Add a PhyloPic to a base R plot
#'
#' Specify an existing image, taxonomic name, or PhyloPic uuid to add a PhyloPic
#' silhouette on top of an existing base R plot.
#'
#' @param img A [Picture][grImport2::Picture-class] or png array object, e.g.,
#'   from using [get_phylopic()].
#' @param name \code{character}. A taxonomic name to be passed to [get_uuid()].
#' @param uuid \code{character}. A valid uuid for a PhyloPic silhouette (such as
#'   that returned by [get_uuid()] or [pick_phylopic()]).
#' @param x \code{numeric}. x value of the silhouette center. Ignored if `y` and
#'   `ysize` are not specified.
#' @param y \code{numeric}. y value of the silhouette center. Ignored if `x` and
#'   `ysize` are not specified.
#' @param ysize \code{numeric}. Height of the silhouette. The width is
#'   determined by the aspect ratio of the original image. Ignored if `x` and
#'   `y` are not specified.
#' @param alpha \code{numeric}. A value between 0 and 1, specifying the opacity
#'   of the silhouette (0 is fully transparent, 1 is fully opaque).
#' @param color \code{character}. Color to plot the silhouette in. If "original"
#'   is specified, the original color of the silhouette will be used.
#' @param horizontal \code{logical}. Should the silhouette be flipped
#'   horizontally?
#' @param vertical \code{logical}. Should the silhouette be flipped vertically?
#' @param angle \code{numeric}. The number of degrees to rotate the silhouette
#'   clockwise. The default is no rotation.
#' @details One (and only one) of `img`, `name`, or `uuid` must be specified.
#'   Use parameters `x`, `y`, and `ysize` to place the silhouette at a specified
#'   position on the plot. If all three of these parameters are unspecified,
#'   then the silhouette will be plotted to the full height and width of the
#'   plot. The aspect ratio of the silhouette will always be maintained (even
#'   when a plot is resized). However, if the plot is resized after plotting the
#'   silhouette, the absolute size and/or position of the silhouette may change.
#'
#'   Any argument may be a vector of values if multiple silhouettes should be
#'   plotted. In this case, all other arguments may also be vectors of values,
#'   which will be recycled as necessary to the length of the longest vector
#'   argument.
#'
#'   When specifying a horizontal and/or vertical flip **and** a rotation, the
#'   flip(s) will always occur first. If you would like to customize this
#'   behavior, you can flip and/or rotate the image within your own workflow
#'   using [flip_phylopic()] and [rotate_phylopic()].
#'
#'   Note that png array objects can only be rotated by multiples of 90 degrees.
#' @importFrom graphics par
#' @importFrom grid grid.raster gpar
#' @importFrom grImport2 grid.picture
#' @importFrom methods is
#' @export
#' @examples
#' # single image
#' plot(1, 1, type = "n", main = "A cat")
#' add_phylopic_base(name = "Cat", x = 1, y = 1, ysize = .4)
#'
#' # lots of images using a uuid
#' posx <- runif(10, 0, 1)
#' posy <- runif(10, 0, 1)
#' size <- runif(10, 0.1, 0.3)
#' angle <- runif(10, 0, 360)
#' hor <- sample(c(TRUE, FALSE), 10, TRUE)
#' ver <- sample(c(TRUE, FALSE), 10, TRUE)
#' cols <- sample(c("black", "darkorange", "grey42", "white"), 10,
#'                replace = TRUE)
#'
#' plot(posx, posy, type = "n", main = "A cat herd")
#' add_phylopic_base(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
#'                   x = posx, y = posy, ysize = size,
#'                   color = cols, angle = angle,
#'                   horizontal = hor, vertical = ver)
#'
#' # Example using a cat background
#' cat <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
#' # setup plot area
#' plot(posx, posy, type = "n", main = "A cat herd, on top of a cat",
#'      xlim = c(0,1), ylim = c(0,1))
#' # plot background cat
#' add_phylopic_base(img = cat, alpha=0.2)
#' # overlay smaller cats
#' add_phylopic_base(img = cat, x = posx, y = posy, ysize = size, alpha=.8)
add_phylopic_base <- function(img = NULL, name = NULL, uuid = NULL,
                              x = NULL, y = NULL, ysize = NULL,
                              alpha = 1, color = "black",
                              horizontal = FALSE, vertical = FALSE,
                              angle = 0) {
  if (all(sapply(list(img, name, uuid), is.null))) {
    stop("One of `img`, `name`, or `uuid` is required.")
  }
  if (sum(sapply(list(img, name, uuid), is.null)) < 2) {
    stop("Only one of `img`, `name`, or `uuid` may be specified")
  }
  if (any(alpha > 1 | alpha < 0)) {
    stop("`alpha` must be between 0 and 1.")
  }

  if (!is.null(name)) {
    if (!is.character(name)) {
      stop("`name` should be of class character.")
    }
    # Get PhyloPic for each unique name
    name_unique <- unique(name)
    imgs <- sapply(name_unique, function(x) {
      url <- tryCatch(get_uuid(name = x, url = TRUE),
                      error = function(cond) NA)
      if (is.na(url)) {
        warning(paste0("`name` ", '"', x, '"',
                       " returned no PhyloPic results."))
        return(NULL)
      }
      get_svg(url)
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

  # get plot limits
  usr <- par()$usr
  usr_x <- if (par()$xlog) 10^usr[1:2] else usr[1:2]
  usr_y <- if (par()$ylog) 10^usr[3:4] else usr[3:4]

  # get plot area percentages
  # note that this means that changing the plot size AFTER plotting may
  # affect the position of the PhyloPic
  plt <- par()$plt
  plt_x <- plt[1:2]
  plt_y <- plt[3:4]

  # get figure limits
  width <- diff(usr_x) / diff(plt_x)
  xlims <- c(usr_x[1] - plt_x[1] * width, usr_x[2] + (1 - plt_x[2]) * width)
  height <- diff(usr_y) / diff(plt_y)
  ylims <- c(usr_y[1] - plt_y[1] * height, usr_y[2] + (1 - plt_y[2]) * height)

  # set default position and size if need be
  if (is.null(x)) x <- mean(usr_x)
  if (is.null(y)) y <- mean(usr_y)
  if (is.null(ysize)) ysize <- abs(diff(usr_y))

  # convert x, y, and ysize to percentages
  x <- (x - xlims[1]) / diff(xlims)
  y <- (y - ylims[1]) / diff(ylims)
  ysize <- ysize / abs(diff(ylims))

  tmp <- mapply(function(img, x, y, ysize, alpha, color, horizontal, vertical, angle) {
    if (horizontal || vertical) img <- flip_phylopic(img, horizontal, vertical)
    if (angle != 0) img <- rotate_phylopic(img, angle)

    # grobify (and recolor if necessary)
    color <- if (color == "original") NULL else color
    if (is(img, "Picture")) { # svg
      gp_fun <- function(pars) {
        if (!is.null(color)) {
          pars$fill <- color
        }
        pars$alpha <- alpha
        pars
      }
      grid.picture(img, x = x, y = y, height = ysize, gpFUN = gp_fun,
                   expansion = 0)
    } else { # png
      img <- recolor_phylopic(img, alpha, color)
      grid.raster(img, x = x, y = y, height = ysize)
    }
  }, img = imgs, x = x, y = y, ysize = ysize, alpha = alpha, color = color,
     horizontal = horizontal, vertical = vertical, angle = angle)
}
