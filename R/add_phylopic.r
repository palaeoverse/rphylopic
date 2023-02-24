#' Input an image and create a ggplot2 layer to add to an existing plot
#'
#' @export
#' @importFrom grImport2 pictureGrob
#' @importFrom grid rasterGrob gList gTree
#' @param img A png object, e.g, from using [image_data()]
#' @param alpha A value between 0 and 1, specifying the opacity of the 
#' silhouette.
#' @param x x value of the silhouette center. Ignored if y and ysize are not 
#' specified.
#' @param y y value of the silhouette center. Ignored if x and ysize are not 
#' specified.
#' @param ysize Height of the silhouette. The width is determined by the aspect 
#' ratio of the original image. Ignored if x and y are not specified.
#' @param color Color to plot the silhouette in. 
#' @details Use parameters `x`, `y`, and `ysize` to place the silhouette at a 
#' specified position on the plot. If all three of these parameters are 
#' unspecified, then the silhouette will be plotted to the full height and width 
#' of the plot.
#' @examples \dontrun{
#' # Put a silhouette behind a plot
#' library(ggplot2)
#' img <- image_data("27356f15-3cf8-47e8-ab41-71c6260b2724", size = "512")[[1]]
#' qplot(x=Sepal.Length, y=Sepal.Width, data=iris, geom="point") + 
#'   add_phylopic(img)
#'
#' # Put a silhouette anywhere
#' library(ggplot2)
#' posx <- runif(50, 0, 10)
#' posy <- runif(50, 0, 10)
#' sizey <- runif(50, 0.4, 2)
#' cols <- sample(c("black", "darkorange", "grey42", "white"), 50, 
#'   replace = TRUE)
#'
#' cat <- image_data("23cd6aa4-9587-4a2e-8e26-de42885004c9", size = 128)[[1]]
#' (p <- ggplot(data.frame(cat.x = posx, cat.y = posy), aes(cat.x, cat.y)) + 
#'  geom_point(color = rgb(0,0,0,0)))
#' for (i in 1:50) {
#'   p <- p + add_phylopic(cat, 1, posx[i], posy[i], sizey[i], cols[i])
#' }
#' p + ggtitle("R Cat Herd!!")
#' }

add_phylopic <- function(img, name = NULL,
                         x = NULL, y = NULL, ysize = NULL,
                         alpha = 1, color = "black") {

  # get aspect ratio
  if (is(img, "Picture")) { # svg
    aspratio <- abs(diff(img@summary@xscale))/abs(diff(img@summary@yscale))
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
    gpFUN <- function(pars) {
      if (!is.null(color)) {
        pars$col <- color
        pars$fill <- color
      }
      pars$alpha <- alpha
      pars
    }
    # copied from
    # https://github.com/k-hench/hypoimg/blob/master/R/hypoimg_recolor_svg.R
    imgGrob <- pictureGrob(img, gpFUN = gpFUN)
    imgGrob <- gList(imgGrob)
    imgGrob <- gTree(children = imgGrob)
  } else { # png
    img <- recolor_png(img, alpha, color)
    imgGrob <- rasterGrob(img)
  }
  
  return(
    inset(imgGrob, xmin = xmin, ymin = ymin, xmax = xmax, ymax = ymax)
    # use this instead of annotation_custom to support all coords
  )
}
