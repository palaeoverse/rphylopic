#' Add a PhyloPic legend for a base R plot
#'
#' Specify existing images, taxonomic names, or PhyloPic uuids to add PhyloPic
#' silhouettes as a legend to an existing base R plot (like [legend()]).
#'
#' @param ysize \code{numeric}. Height of the silhouette. The width is
#'   determined by the aspect ratio of the original image.
#' @inheritParams add_phylopic_base
#' @param ... Additional arguments passed to [legend()].
#'   
#' @details This function can be used to add PhyloPic silhouettes as a
#' legend to a base R plot. Arguments available in [legend()] can be used and 
#' passed via `...`. Note that not all arguments in [legend()] are compatible
#' with [add_phylopic_legend()], such as `pch` and `lwd`. However, in general,
#' arguments for adjusting the legend appearance such as text (e.g. `cex`), 
#' legend box (e.g. `bg`), and color (e.g. `border`) are.
#' @importFrom graphics legend
#' @export
#' @examples
#' # Get UUIDs
#' uuids <- get_uuid(name = "Canis lupus", n = 2)
#' # Generate empty plot
#' plot(0:10, 0:10, type = "n", main = "Wolfs")
#' # Add data points
#' add_phylopic_base(uuid = uuids,
#'   color = "black", fill = c("blue", "green"),
#'   x = c(2.5, 7.5), y = c(2.5, 7.5), ysize = 2)
#' # Add legend
#' add_phylopic_legend(uuid = uuids, 
#'   ysize = 0.5, color = "black", fill = c("blue", "green"), 
#'   x = "bottomright", legend = c("Wolf 1", "Wolf 2"),
#'   bg = "lightgrey")
add_phylopic_legend <- function(img = NULL, name = NULL, uuid = NULL, 
                                ysize = NULL, color = NA, fill = "black", 
                                ...) {
  # Get supplied arguments
  args <- list(...)
  # Filter unrequired arguments 
  dump <- c("lty", "lwd", "pch", "angle", "density", "pt.lwd", "merge")
  if (any(names(args) %in% dump)) {
    args <- args[-which(names(args) %in% dump)]
  }
  # Do call
  leg_pos <- do.call(legend, args)
  # Extract arguments if provided via legend for plotting
  # color values
  col <- args[["col"]]
  if (!is.null(col)) color <- col
  border <- args[["border"]]
  if (!is.null(border)) color <- border
  # fill value
  bg <- args[["pt.bg"]]
  if (!is.null(bg)) fill <- bg
  # size values
  size <- args[["pt.cex"]]
  if (!is.null(size)) ysize <- size
  # Set default ysize if required
  if (is.null(ysize)) ysize <- (abs(diff(leg_pos$text$y)) * 0.5)
  # Extract positions
  # Adjust x position slightly to account for width
  x <- leg_pos$text$x * 0.98
  y <- leg_pos$text$y
  # Plot
  add_phylopic_base(uuid = uuid,
                    x = x, 
                    y = y, 
                    color = color,
                    fill = fill,
                    ysize = ysize)
}
