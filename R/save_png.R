#' Save an image to disk as a `.png` file
#'
#' @export
#' @param img A png object, e.g, from using [image_data()]
#' @param target the file or other connection to write to, passed
#' on to [png::writePNG], see its docs for details. By default 
#' we use `tempfile(fileext = ".png")`, a temporary `.png` file
#' which is cleaned up (deleted) at the end of the R session
#' @param ... additional parameters passed on to [png::writePNG]
#' @return path to the `.png` file on disk
#' @examples \dontrun{
#' # get a silhouette
#' cat <- image_data("23cd6aa4-9587-4a2e-8e26-de42885004c9", size = 128)[[1]]
#' 
#' # save image
#' out <- save_png(cat)
#' identical(png::readPNG(out), cat)
#' 
#' save_png(cat, dpi = 1000)
#' }
save_png <- function(img, target = tempfile(fileext = ".png"), ...) {
  png::writePNG(img, target = target, ...)
  return(target)
}
