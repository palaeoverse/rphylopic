#' Save a PhyloPic image
#' 
#' `save_phylopic` is a convenient function for saving a PhyloPic image.
#' Available formats for saving include svg, pdf, png, ps, and eps. 
#'
#' @param img \code{Picture?}.
#' @param path \code{character}.
#' @param width \code{numeric}.
#' @param height \code{numeric}.
#'
#' @return
#'
#' @details
#'
#' @importFrom rsvg rsvg_pdf rsvg_svg rsvg_png rsvg_ps rsvg_eps
#' @export
#' @examples
save_phylopic <- function(img = NULL, path = NULL,
                          width = NULL, height = NULL) {
  # Error handling -----------------------------------------------------
  # Image checking
  if (is.null(img)) {
    stop("`img` is required.")
  }
  if (class(img) != "Picture") {
    stop("`img` should be of class Picture.")
  }
  # Dimension checking
  if (is.null(width)) {
    stop("Output `width` is required (in pixels).")
  }
  if (is.null(height)) {
    stop("Output `height` is required (in pixels).")
  }
  # If path is NULL use current working directory and svg
  if (is.null(path)) {
    warning("No path was provided. Using current working directory.")
    path <- paste0(getwd(), c("/phylopic.svg"))
  }
  # Define available save formats
  available_formats <- c("pdf", "png", "svg", "ps", "eps")
  # Get file type for function selection
  type <- tools::file_ext(path)
  # Check for output format
  if (!type %in% available_formats) {
    msg <- paste0(type, " format not supported by this function.",
                  " Use one of the following: ", toString(available_formats))
    stop(msg)
  }
  # Save image ---------------------------------------------------------
  # Generate function list of different format
  formats <- list(pdf = rsvg_pdf,
                  png = rsvg_png,
                  svg = rsvg_svg,
                  ps = rsvg_ps,
                  eps = rsvg_eps)
  # Filter for correct function
  fun <- formats[[type]]
  # Save file
  fun(svg = img, file = path, width = width, height = height) 
}
