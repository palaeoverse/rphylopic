#' Add a PhyloPic legend for a base R plot
#'
#' Specify existing images, taxonomic names, or PhyloPic uuids to add PhyloPic
#' silhouettes as a legend to an existing base R plot (like [legend()]).
#'
#' @param x \code{numeric or character}. Either the x coordinate to be used
#'   to position the legend or a keyword accepted by [legend()] such as 
#'   "topleft", "topright", "bottomleft", and "bottomright".
#' @param y \code{numeric}. The y coordinate to be used to position the 
#'   legend. Can be `NULL` (default) if using keywords in `x`.
#' @param legend \code{character}. A character vector of the labels to appear
#'   in the legend.
#' @param ysize `r lifecycle::badge("deprecated")` use the `height`
#'   argument instead.
#' @param height \code{numeric}. Height of the legend silhouette(s). The width 
#'   is determined by the aspect ratio of the original image.
#' @inheritParams add_phylopic_base
#' @param ... Additional arguments passed to [legend()].
#'   
#' @details This function can be used to add PhyloPic silhouettes as a legend
#'   to a base R plot. Arguments available in [legend()] can be used and
#'   passed via `...`. Note that not all arguments in [legend()] are
#'   compatible with [add_phylopic_legend()]. These include arguments for
#'   modifying lines (e.g. `lty`, `lwd`, `seg.len`), points (e.g. `pch`,
#'   `pt.lwd`), and shading (e.g. `angle` and `density`). This is due to
#'   [add_phylopic_legend()] using [add_phylopic_base()] to generate the
#'   legend symbols. However, arguments for adjusting the legend appearance
#'   such as text (e.g. `cex`), legend box (e.g. `bg`), and color (e.g.
#'   `border`) are compatible.
#' @importFrom graphics legend
#' @export
#' @examples
#' # Get UUIDs
#' uuids <- get_uuid(name = "Canis lupus", n = 2)
#' # Generate empty plot
#' plot(0:10, 0:10, type = "n", main = "Wolves")
#' # Add data points
#' add_phylopic_base(uuid = uuids,
#'   color = "black", fill = c("blue", "green"),
#'   x = c(2.5, 7.5), y = c(2.5, 7.5), height = 2)
#' # Add legend
#' add_phylopic_legend(uuid = uuids, 
#'   height = 0.5, color = "black", fill = c("blue", "green"), 
#'   x = "bottomright", legend = c("Wolf 1", "Wolf 2"),
#'   bg = "lightgrey")
add_phylopic_legend <- function(x, y = NULL, legend,
                                img = NULL, name = NULL, uuid = NULL, 
                                ysize = deprecated(), height = NULL,
                                color = NA, fill = "black", 
                                ...) {
  if (lifecycle::is_present(ysize)) {
    lifecycle::deprecate_warn("1.4.0", "add_phylopic_legend(ysize)",
                              "add_phylopic_legend(height)")
    if (is.null(height)) height <- ysize
  }
  # Get supplied arguments
  args <- list(x = x, y = y, legend = legend, ...)
  # Remove legend object to avoid issues with do.call
  remove(legend)
  # Filter unrequired arguments 
  dump <- c("lty", "lwd", "seg.len", "pch", "angle", "density", "pt.lwd")
  if (any(names(args) %in% dump)) {
    args <- args[-which(names(args) %in% dump)]
  }
  # Do call
  leg_pos <- do.call(what = legend, args = args)
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
  if (!is.null(size)) height <- size
  # Set default ysize if required
  if (is.null(height)) height <- (abs(diff(leg_pos$text$y)) * 0.5)
  # Extract positions
  # Adjust x position slightly to account for width
  x <- (leg_pos$text$x + leg_pos$rect$left) / 2
  y <- leg_pos$text$y
  # Plot
  add_phylopic_base(uuid = uuid,
                    x = x, 
                    y = y, 
                    color = color,
                    fill = fill,
                    height = height)
}
