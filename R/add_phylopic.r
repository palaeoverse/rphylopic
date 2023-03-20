#' Add a PhyloPic to a ggplot plot
#'
#' Specify an existing image, taxonomic name, or PhyloPic uuid to add a PhyloPic
#' silhouette as a separate layer to an existing ggplot plot.
#'
#' @param img A [Picture][grImport2::Picture-class] or png array object, e.g.,
#'   from using [get_phylopic()].
#' @param name A taxonomic name to be passed to [get_uuid()].
#' @param uuid A valid uuid for a PhyloPic silhouette (such as that returned by
#'   [get_uuid()] or [pick_phylopic()]).
#' @param x x value of the silhouette center. Ignored if `y` and `ysize` are not
#'   specified.
#' @param y y value of the silhouette center. Ignored if `x` and `ysize` are not
#'   specified.
#' @param ysize Height of the silhouette. The width is determined by the aspect
#'   ratio of the original image. Ignored if `x` and `y` are not specified.
#' @param alpha A value between 0 and 1, specifying the opacity of the
#'   silhouette (0 is fully transparent, 1 is fully opaque).
#' @param color Color to plot the silhouette in.
#' @details One (and only one) of `img`, `name`, or `uuid` must be specified.
#'   Use parameters `x`, `y`, and `ysize` to place the silhouette at a specified
#'   position on the plot. If all three of these parameters are unspecified,
#'   then the silhouette will be plotted to the full height and width of the
#'   plot. The aspect ratio of the silhouette will always be maintained.
#' @importFrom grImport2 pictureGrob
#' @importFrom grid rasterGrob gList gTree
#' @importFrom methods is
#' @export
#' @examples
#' # Put a silhouette behind a plot based on a taxonomic name
#' library(ggplot2)
#' ggplot(iris) +
#'   add_phylopic(name = "Iris", alpha = .2) +
#'   geom_point(aes(x = Sepal.Length, y = Sepal.Width))
#'
#' # Put a silhouette anywhere based on UUID
#' posx <- runif(10, 0, 10)
#' posy <- runif(10, 0, 10)
#' sizey <- runif(10, 0.4, 2)
#' cols <- sample(c("black", "darkorange", "grey42", "white"), 10,
#'   replace = TRUE)
#'
#' # Since we are plotting a lot of the same image, we should just save
#' # the image in our environment first
#' cat <- get_phylopic("23cd6aa4-9587-4a2e-8e26-de42885004c9")
#' p <- ggplot(data.frame(cat.x = posx, cat.y = posy), aes(cat.x, cat.y))
#' for (i in 1:10) {
#'   p <- p + add_phylopic(cat, x = posx[i], y = posy[i],
#'                         ysize = sizey[i], color = cols[i])
#' }
#' p + ggtitle("R Cat Herd!!")
add_phylopic <- function(img = NULL, name = NULL, uuid = NULL,
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
      stop("`name` returned no PhyloPic results.")
    }
    img <- get_svg(url)
  } else if (!is.null(uuid)) {
    if (!is.character(uuid)) {
      stop("`uuid` should be of class character.")
    }
    img <- get_phylopic(uuid)
  } else if (!is(img, "Picture") && !is.array(img)) {
    stop("`img` should be of class Picture (for a vector image) or class array
          (for a raster image).")
  }

  # get aspect ratio
  if (is(img, "Picture")) { # svg
    aspratio <- abs(diff(img@summary@xscale)) / abs(diff(img@summary@yscale))
  } else { # png
    aspratio <- ncol(img) / nrow(img)
  }

  if (!is.null(x) && !is.null(y) && !is.null(ysize)) {
    ymin <- y - ysize / 2
    ymax <- y + ysize / 2
    xmin <- x - ysize * aspratio / 2
    xmax <- x + ysize * aspratio / 2
  } else {
    ymin <- -Inf ## fill whole plot...
    ymax <- Inf
    xmin <- -Inf
    xmax <- Inf
  }

  # grobify (and recolor if necessary)
  if (is(img, "Picture")) { # svg
    gp_fun <- function(pars) {
      if (!is.null(color)) {
        pars$fill <- color
      }
      pars$alpha <- alpha
      pars
    }
    # modified from
    # https://github.com/k-hench/hypoimg/blob/master/R/hypoimg_recolor_svg.R
    img_grob <- pictureGrob(img, gpFUN = gp_fun)
    img_grob <- gList(img_grob)
    img_grob <- gTree(children = img_grob)
  } else { # png
    img <- recolor_png(img, alpha, color)
    img_grob <- rasterGrob(img)
  }

  return(
    # use this instead of annotation_custom to support all coords
    phylopic_inset(img_grob, xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax)
  )
}
