#' Add a phylopic to a base R plot
#'
#' Specify an existing image, taxonomic name, or phylopic uuid to add a phylopic
#' silhouette on top of an existing base R plot.
#'
#' @param img A Picture or png array object, e.g., from using [image_data()].
#' @param name A taxonomic name to be passed to [get_uuid()].
#' @param uuid A valid uuid for a phylopic silhouette (such as that returned by
#'   [get_uuid()] or [pick_phylo()]).
#' @param x x value of the silhouette center. Ignored if y and ysize are not
#'   specified.
#' @param y y value of the silhouette center. Ignored if x and ysize are not
#'   specified.
#' @param ysize Height of the silhouette. The width is determined by the aspect
#'   ratio of the original image. Ignored if x and y are not specified.
#' @param alpha A value between 0 and 1, specifying the opacity of the
#'   silhouette.
#' @param color Color to plot the silhouette in.
#' @details One (and only one) of `img`, `name`, or `uuid` must be specified.
#'   Use parameters `x`, `y`, and `ysize` to place the silhouette at a specified
#'   position on the plot. If all three of these parameters are unspecified,
#'   then the silhouette will be plotted to the full height and width of the
#'   plot. The aspect ratio of the silhouette will always be maintained (even
#'   when a figure is resized). However, if the plot is resized afterwards, the
#'   absolute position of the silhouette may change.
#' @importFrom graphics par
#' @importFrom grid grid.raster gpar
#' @importFrom grImport2 grid.picture
#' @importFrom methods is
#' @export
#' @examples
#' # single image
#' plot(1, 1, type="n", main="A cat")
#' add_phylopic_base(name = "Cat", x = 1, y = 1, ysize = .4)
#'
#' # lots of images using a uuid
#' posx <- runif(50, 0, 1)
#' posy <- runif(50, 0, 1)
#' size <- runif(50, 0.01, 0.2)
#'
#' # Since we are plotting a lot of the same image, we should just save
#' # the image in our environment first
#' cat <- image_data("23cd6aa4-9587-4a2e-8e26-de42885004c9")
#'
#' plot(posx, posy, type="n", main="A cat herd")
#' for (i in 1:50) {
#'   add_phylopic_base(cat, x = posx[i], y = posy[i], ysize = size[i])
#' }
#'
#' # Example using a cat background
#' # setup plot area
#' plot(posx, posy, type="n", main="A cat herd, on top of a cat",
#'      xlim=c(0,1), ylim=c(0,1))
#' # plot background cat
#' add_phylopic_base(cat, alpha=0.2)
#' # overlay smaller cats
#' for (i in 1:50) {
#'   add_phylopic_base(cat, x = posx[i], y = posy[i], ysize = size[i], alpha=.8)
#' }
add_phylopic_base <- function(img = NULL, name = NULL, uuid = NULL,
                              x = NULL, y = NULL, ysize = NULL,
                              alpha = 1, color = "black") {
  if (all(sapply(list(img, name, uuid), is.null))) {
    stop("One of `img`, `name`, or `uuid` is required.")
  }
  if (sum(sapply(list(img, name, uuid), is.null)) < 2) {
    stop("Only one of `img`, `name`, or `uuid` may be specified")
  }
  if (alpha > 1 || alpha < 0) {
    stop("`alpha` must be between 0 and 1.")
  }
  if (!is.null(name)) {
    if (!is.character(name)) {
      stop("`name` should be of class character.")
    }
    url <- get_uuid(name = name, url = TRUE)
    if (is.na(url)) {
      stop("`name` returned no phylopic results.")
    }
    img <- get_svg(url)
  } else if (!is.null(uuid)) {
    if (!is.character(uuid)) {
      stop("`uuid` should be of class character.")
    }
    img <- image_data(uuid)
  } else if (!is(img, "Picture") && !is.array(img)) {
    stop("`img` should be of class Picture (for a vector image) or class array
          (for a raster image).")
  }
  
  # get plot limits
  usr <- par()$usr
  usr_x <- if (par()$xlog) 10^usr[1:2] else usr[1:2]
  usr_y <- if (par()$ylog) 10^usr[3:4] else usr[3:4]
  
  # get plot area percentages
  # note that this means that changing the plot size AFTER plotting may
  # affect the position of the phylopic
  plt <- par()$plt
  plt_x <- plt[1:2]
  plt_y <- plt[3:4]
  
  # get figure limits
  width <- diff(usr_x)/diff(plt_x)
  xlims <- c(usr_x[1] - plt_x[1] * width, usr_x[2] + (1 - plt_x[2]) * width)
  height <- diff(usr_y)/diff(plt_y)
  ylims <- c(usr_y[1] - plt_y[1] * height, usr_y[2] + (1 - plt_y[2]) * height)
  
  # set default position and size if need be
  if (is.null(x)) x <- mean(usr_x)
  if (is.null(y)) y <- mean(usr_y)
  if (is.null(ysize)) ysize <- abs(diff(usr_y))
  
  # convert x, y, and ysize to percentages
  x <- (x - xlims[1])/diff(xlims)
  y <- (y - ylims[1])/diff(ylims)
  ysize <- ysize/abs(diff(ylims))

  if (is(img, "Picture")) { # svg
    gpFUN <- function(pars) {
      if (!is.null(color)) {
        pars$col <- color
        pars$fill <- color
      }
      pars$alpha <- alpha
      pars
    }
    grid.picture(img, x = x, y = y, height = ysize, gpFUN = gpFUN)
  } else { # png
    img <- recolor_png(img, alpha, color)
    grid.raster(img, x = x, y = y, height = ysize)
  }
}
