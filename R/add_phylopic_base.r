#' Input an image and add to an existing plot made with base graphics
#'
#' @export
#' @param img A png object, e.g, from using \code{\link{get_image}}
#' @param x x value of the silhouette center. Ignored if y and ysize are not specified.
#' @param y y value of the silhouette center. Ignored if x and ysize are not specified.
#' @param ysize Height of the silhouette. The width is determined by the aspect ratio 
#' of the original image. Ignored if x and y are not specified.
#' @param alpha A value between 0 and 1, specifying the opacity of the silhouette.
#' @param color Color to plot the silhouette in.
#' @details Use parameters \code{x}, \code{y}, and \code{ysize} to place the silhouette 
#' at a specified position on the plot. If all three of these parameters are unspecified, 
#' then the silhouette will be plotted to the full height and width of the plot.
#' @examples \dontrun{
#' # get a silhouette
#' cat <- image_data("23cd6aa4-9587-4a2e-8e26-de42885004c9", size = 128)[[1]]
#' 
#' # single image
#' plot(1, 1, type="n", main="A cat herd")
#' add_phylopic_base(cat, 0.5, 0.5, 0.2)
#' 
#' # lots of images
#' posx <- runif(50, 0, 1)
#' posy <- runif(50, 0, 1)
#' size <- runif(50, 0.01, 0.2)
#' plot(posx, posy, type="n", main="A cat herd")
#' for (i in 1:50) {
#'   add_phylopic_base(cat, posx[i], posy[i], size[i])
#' }
#' }
add_phylopic_base <- function(img, x = NULL, y = NULL, ysize = NULL, 
                              alpha = 0.2, color = NULL) {
  # color and alpha the animal
  img <- recolor_phylopic(img, alpha, color)
  
  #number of x-y pixels for the logo (aspect ratio)
  dims <- dim(img)[1:2]
  AR <- dims[1] / dims[2]
  par(usr = c(0, 1, 0, 1))
  rasterImage(img, x - (ysize/2), y - (AR*ysize/2), x + (ysize/2), y + (AR*ysize/2), interpolate = TRUE)
}

# add_phylopic_base <- function(img, alpha = 0.2, x = NULL, y = NULL, 
#                               ysize = NULL, color = NULL) {
# 
#   # handle the null device -- no graphics yet
#   if (attr(grDevices::dev.cur(), "names") == "null device") {
#     stop("plot.new has not been called yet")
#   }
# 
#   # color and alpha the animal
#   mat <- recolor_phylopic(img, alpha, color)
# 
#   if (is.null(x) && is.null(y) && is.null(ysize)) {
#     ## fill whole plot...
#     x <- mean(par("usr")[1:2])
#     y <- mean(par("usr")[3:4])
# 
#     ysize <- abs(diff(par("usr")[3:4]))
# 
#     aspratio <- nrow(mat) / ncol(mat) ## get aspect ratio of original image
#     
#     if (ysize/aspratio > abs(diff(par("usr")[1:2]))) {
#       ysize <- ysize*aspratio
#     }
#   }
# 
#   # get the viewport to get the alignment right for grid.raster
#   vps <- gridBase::baseViewports()
#   grid::pushViewport(vps$inner, vps$figure, vps$plot)
# 
#   # plot the raster
#   grid::grid.raster(mat, x = x, y = y, default.units = "native",
#                     height = ysize, just = "centre")
# 
#   # make sure to pop the viewport otherwise everything goes horribly wrong
#   grid::popViewport()
# }
