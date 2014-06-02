#' Get an image from a uuid.
#'
#' @import RCurl png
#' @param uuids One to many uuids, possibly from the function search_images
#' @seealso \code{\link{search_images}}
#' @examples \dontrun{
#' toget <- c("27356f15-3cf8-47e8-ab41-71c6260b2724", "bd88f674-6976-4cb2-a46e-e6a12a8ba463", "e547cd01-7dd1-495b-8239-52cf9971a609")
#' get_image(uuids = toget, size = "512")
#' get_image(uuids = toget, size = "thumb")
#'
#' # Put a silhouette behind a plot
#' library(ggplot2)
#' img <- get_image("27356f15-3cf8-47e8-ab41-71c6260b2724", size = "512")[[1]]
#' qplot(x=Sepal.Length, y=Sepal.Width, data=iris, geom="point") + add_phylopic(img)
#' }
#' @export
get_image <- function(uuids, size)
{
  if(class(uuids)=="list")
    uuids <- rphylopic:::unnest(uuids)$all

  out <- lapply(uuids, function(x) readPNG(getURLContent(paste0("http://phylopic.org/assets/images/submissions/", x, ".", size, ".png"))))
  return( out )
}
