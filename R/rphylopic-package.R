#' rphylopic
#' 
#' Get Silhouettes of Organisms from Phylopic
#'
#' @importFrom grid popViewport grid.raster pushViewport rasterGrob
#' @importFrom gridBase baseViewports
#' @importFrom grDevices col2rgb rgb dev.cur
#' @importFrom graphics par rasterImage
#' @importFrom ggplot2 annotation_custom element_text
#' @importFrom crul HttpClient
#' @importFrom jsonlite fromJSON
#' @importFrom png readPNG writePNG
#' @name rphylopic
#' @aliases rphylopic-package
#' @author Scott Chamberlain \email{myrmecocystus@@gmail.com}
#' @author David Miller \email{dave@@ninepointeightone.net}
#' @docType package
NULL

#' This function is defunct.
#' @export
#' @rdname plot_phylopic_base-defunct
#' @keywords internal
#' @note see [add_phylopic_base()]
plot_phylopic_base <- function(...) {
  .Defunct(msg = "`plot_phylopic_base` is defunct; use `?add_phylopic_base`")
}
