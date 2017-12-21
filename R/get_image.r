#' Get data for an image or many images.
#'
#' @export
#' @param input Either a vector of uuids or the output from the function \code{search_images}
#' @param size Height of the image, one of 64, 128, 256, 512, 1024, "thumb", or "icon"
#'
#' @seealso \code{\link{search_images}}
#' @examples \dontrun{
#' # input uuids
#' toget <- c("c089caae-43ef-4e4e-bf26-973dd4cb65c5", "41b127f6-0824-4594-a941-5ff571f32378",
#'    "9c6af553-390c-4bdd-baeb-6992cbc540b1")
#' get_image(toget, size = "64")
#' get_image(toget, size = "thumb")
#'
#' # input the output from search_images
#' searchres <- search_text(text = "Homo sapiens", options = "names")
#' output <- search_images(uuid=searchres, options=c("pngFiles", "credit", "canonicalName"))
#' get_image(output, size = "icon")
#'
#' # Put a silhouette behind a plot
#' library('ggplot2')
#' img <- get_image("27356f15-3cf8-47e8-ab41-71c6260b2724", size = "512")[[1]]
#' qplot(x=Sepal.Length, y=Sepal.Width, data=iris, geom="point") + add_phylopic(img)
#'
#' # Use as points in a ggplot plot
#' library('ggplot2')
#' uuid <- "c089caae-43ef-4e4e-bf26-973dd4cb65c5"
#' img <- get_image(uuid, size = "64")[[1]]
#' (p <- ggplot(mtcars, aes(drat, wt)) + geom_blank())
#' for(i in 1:nrow(mtcars)) p <- p + add_phylopic(img, 1, mtcars$drat[i], mtcars$wt[i], ysize = 0.3)
#' p
#' }

get_image <- function(input, size) {
  .Deprecated("image_data", "rphylopic", "Function will be removed soon. See image_data()")
  size <- match.arg(as.character(size), c("64", "128", "256", "512", "1024", "thumb", "icon"))

  if (inherits(input, "image_info")) {
    if (!size %in% c('thumb','icon')) {
      urls <- input[ as.character(input$height) == size , "url" ]
      urls <- sapply(urls, function(x) file.path("http://phylopic.org", x), USE.NAMES = FALSE)
    } else {
      tmp <- vapply(split(input, input$uuid), function(x) x$url[1], "", USE.NAMES = FALSE)
      urls <- paste0(gsub("\\.64\\.png", "", tmp), sprintf(".%s.png", size))
      urls <- sapply(urls, function(x) file.path("http://phylopic.org", x), USE.NAMES = FALSE)
    }
    lapply(urls, getpng)
  } else {
    lapply(input, function(x) getpng(paste0("http://phylopic.org/assets/images/submissions/", x, ".", size, ".png")))
  }
}
