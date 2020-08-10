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
#' @param xsize Width of the silhouette (optional). If not supplied determined 
#' by `ysize`
#' @param alpha A value between 0 and 1, specifying the opacity of the 
#' silhouette.
#' @param color Color to plot the silhouette in.
#' @details Use parameters `x`, `y`, and `ysize` to place the silhouette 
#' at a specified position on the plot. If all three of these parameters 
#' are unspecified, then the silhouette will be plotted to the full height 
#' and width of the plot.
#' @importFrom graphics par
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
add_phylopic_base <- function(img, x = NULL, y = NULL, ysize = NULL, xsize=NULL,
                              alpha = 0.2, color = NULL) {
  # color and alpha the animal
  img <- recolor_phylopic(img, alpha, color)

  # work out the dimensions of the image
  dims <- dim(img)[1:2]


  # compute the size
  if(is.null(xsize)){
    # aspect ratio for image dimensions
    image_ar <- dims[1] / dims[2]

    # rescale depending on which of the axes is longer
    image_ar <- image_ar * c(diff(par()$yaxp[1:2]),
                             1/diff(par()$xaxp[1:2]))[which.max(
                                c(diff(par()$yaxp[1:2]), diff(par()$xaxp[1:2])))]
    # calculate xsize
    xsize <- ysize / image_ar
  }

  graphics::rasterImage(img,
                        x - xsize/2,
                        y - ysize/2,
                        x + xsize/2,
                        y + ysize/2,
                        interpolate = TRUE)
}
