#' Input an image and create a ggplot2 layer to add to an existing plot
#'
#' @import grid
#' @export
#' @param img A png object, e.g, from using \code{get_image}
#' @examples \dontrun{
#' # Put a silhouette behind a plot
#' library(ggplot2)
#' img <- get_image("27356f15-3cf8-47e8-ab41-71c6260b2724", size = "512")[[1]]
#' qplot(x=Sepal.Length, y=Sepal.Width, data=iris, geom="point") + add_phylopic(img)
#' }

add_phylopic <- function(img){
  mat <- matrix(rgb(img[,,1],img[,,2],img[,,3],img[,,4] * 0.2),nrow=dim(img)[1])
  return(
    annotation_custom(xmin=-Inf, ymin=-Inf, xmax=Inf, ymax=Inf, rasterGrob(mat))
  )
}
