#' Annotate a ggplot plot with PhyloPics
#'
#' Specify existing images, taxonomic names, or PhyloPic uuids to add PhyloPic
#' silhouettes as a separate layer to an existing ggplot plot.
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
#' @param x \code{numeric}. x value of the silhouette center.
#' @param y \code{numeric}. y value of the silhouette center.
#' @param ysize \code{numeric}. Height of the silhouette. The width is
#'   determined by the aspect ratio of the original image. If "Inf", the
#'   default, the height will be as tall as will fit within the plot area.
#' @param alpha \code{numeric}. A value between 0 and 1, specifying the opacity
#'   of the silhouette (0 is fully transparent, 1 is fully opaque).
#' @param color \code{character}. Color of silhouette outline. If "original" or
#'   NA is specified, the original color of the silhouette outline will be used
#'   (usually the same as "transparent"). To remove the outline, you can set
#'   this to "transparent".
#' @param fill \code{character}. Color of silhouette. If "original" is
#'   specified, the original color of the silhouette will be used (usually the
#'   same as "black"). If `color` is specified and `fill` is NA, `color` will be
#'   used as the fill color (for backwards compatibility). To remove the fill,
#'   you can set this to "transparent".
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
#'   position on the plot. The aspect ratio of the silhouette will always be
#'   maintained.
#'
#'   `x` and/or `y` may be vectors of numeric values if multiple silhouettes
#'   should be plotted at once. In this case, any other arguments (except for
#'   `remove_background`) may also be vectors of values, which will be recycled
#'   as necessary.
#'
#'   When specifying a horizontal and/or vertical flip **and** a rotation, the
#'   flip(s) will always occur first. If you would like to customize this
#'   behavior, you can flip and/or rotate the image within your own workflow
#'   using [flip_phylopic()] and [rotate_phylopic()].
#'
#'   Note that png array objects can only be rotated by multiples of 90 degrees.
#'   Also, outline colors do not currently work for png array objects.
#' @importFrom ggplot2 annotate
#' @export
#' @examples
#' # Put a silhouette behind a plot based on a taxonomic name
#' library(ggplot2)
#' ggplot(iris) +
#'   add_phylopic(x = 6.1, y = 3.2, name = "Iris", alpha = 0.2) +
#'   geom_point(aes(x = Sepal.Length, y = Sepal.Width))
#'
#' # Put a silhouette in several places based on UUID
#' posx <- runif(10, 0, 10)
#' posy <- runif(10, 0, 10)
#' sizey <- runif(10, 0.4, 2)
#' angle <- runif(10, 0, 360)
#' hor <- sample(c(TRUE, FALSE), 10, TRUE)
#' ver <- sample(c(TRUE, FALSE), 10, TRUE)
#' fills <- sample(c("black", "darkorange", "grey42", "white"), 10,
#'   replace = TRUE)
#' alpha <- runif(10, 0.3, 1)
#'
#' p <- ggplot(data.frame(cat.x = posx, cat.y = posy), aes(cat.x, cat.y)) +
#'   geom_blank() +
#'   add_phylopic(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
#'                x = posx, y = posy, ysize = sizey,
#'                fill = fills, alpha = alpha, angle = angle,
#'                horizontal = hor, vertical = ver)
#' p + ggtitle("R Cat Herd!!")
add_phylopic <- function(img = NULL, name = NULL, uuid = NULL, filter = NULL,
                         x, y, ysize = Inf,
                         alpha = 1, color = NA, fill = "black",
                         horizontal = FALSE, vertical = FALSE, angle = 0,
                         remove_background = TRUE, verbose = FALSE) {
  if (all(sapply(list(img, name, uuid), is.null))) {
    stop("One of `img`, `name`, or `uuid` is required.")
  }
  if (sum(sapply(list(img, name, uuid), is.null)) < 2) {
    stop("Only one of `img`, `name`, or `uuid` may be specified")
  }
  if (!is.logical(verbose)) {
    stop("`verbose` should be a logical value.")
  }

  # Make all variables the same length
  x_len <- length(x)
  y_len <- length(y)
  max_len <- max(x_len, y_len)
  x <- rep_len(x, max_len)
  y <- rep_len(y, max_len)
  ysize <- rep_len(ysize, max_len)
  alpha <- rep_len(alpha, max_len)
  color <- rep_len(color, max_len)
  fill <- rep_len(fill, max_len)
  horizontal <- rep_len(horizontal, max_len)
  vertical <- rep_len(vertical, max_len)
  angle <- rep_len(angle, max_len)

  # Put together all of the variables
  args <- list(geom = GeomPhylopic,
               x = x, y = y, size = ysize,
               alpha = alpha, color = color, fill = fill,
               horizontal = horizontal, vertical = vertical, angle = angle,
               remove_background = remove_background, verbose = verbose,
               filter = list(filter))
  # Only include the one silhouette argument
  if (!is.null(img)) {
    if (is.list(img)) {
      args$img <- rep_len(img, max_len)
    } else {
      args$img <- rep_len(list(img), max_len)
    }
  }
  if (!is.null(name)) args$name <- rep_len(name, max_len)
  if (!is.null(uuid)) args$uuid <- rep_len(uuid, max_len)

  return(do.call(annotate, args))
}
