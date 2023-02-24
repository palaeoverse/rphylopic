#' Input an image and add to an existing plot made with base graphics
#'
#' @export
#' @param img A png object, e.g, from using [image_data()]
#' @param x x value of the silhouette center. Ignored if y and ysize are 
#' not specified.
#' @param y y value of the silhouette center. Ignored if x and ysize are 
#' not specified.
#' @param ysize Height of the silhouette. The width is determined by the 
#' aspect ratio of the original image. Ignored if x and y are not specified.
#' @param alpha A value between 0 and 1, specifying the opacity of the 
#' silhouette.
#' @param color Color to plot the silhouette in.
#' @details Use parameters `x`, `y`, and `ysize` to place the silhouette 
#' at a specified position on the plot. If all three of these parameters 
#' are unspecified, then the silhouette will be plotted to the full height 
#' and width of the plot.
#' @importFrom graphics par
#' @importFrom grid grid.raster gpar
#' @importFrom grImport2 grid.picture
#' @examples \dontrun{
#' # get a silhouette
#' cat <- image_data("23cd6aa4-9587-4a2e-8e26-de42885004c9", size = 128)[[1]]
#'
#' # single image
#' plot(1, 1, type="n", main="A cat")
#' add_phylopic_base(cat, 1, 1, 0.2)
#'
#' # lots of images
#' posx <- runif(50, 0, 1)
#' posy <- runif(50, 0, 1)
#' size <- runif(50, 0.01, 0.2)
#' plot(posx, posy, type="n", main="A cat herd")
#' for (i in 1:50) {
#'   add_phylopic_base(cat, posx[i], posy[i], size[i])
#' }
#'
#' # Example using a cat background
#' # setup plot area
#' plot(posx, posy, type="n", main="A cat herd, on top of a cat",
#'      xlim=c(0,1), ylim=c(0,1))
#' # get a higher-resolution cat
#' cat_hires <- image_data("23cd6aa4-9587-4a2e-8e26-de42885004c9", size = 512)[[1]]
#' # plot background cat
#' add_phylopic_base(cat_hires, 0.5, 0.5, 1, alpha=0.2)
#' # overlay smaller cats
#' for (i in 1:50) {
#'   add_phylopic_base(cat, posx[i], posy[i], size[i], alpha=.8)
#' }
#' }
add_phylopic_base <- function(img, name = NULL,
                              x = NULL, y = NULL, ysize = NULL,
                              alpha = 1, color = "black") {
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
