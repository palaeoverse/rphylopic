#' Add PhyloPics to a phylogenetic tree plotted with base R
#'
#' Specify existing images, taxonomic names, or PhyloPic uuids to add PhyloPic
#' silhouettes alongside the associated leaves of a phylogenetic tree that has
#' been plotted in the active graphics device using the base R graphics
#' functions. The current functionality assumes that the tree is not in a
#' circular configuration and has a "rightwards" direction.
#'
#' @inheritParams add_phylopic_base
#' @param tree `phylo`. The phylogenetic tree object on which to add the
#'   silhouette.
#' @param tip `character`. The tip labels against which to add the silhouettes. If not
#'   specified, the names of the `img`, `uuid` or `name` vector are used.
#' @param align \code{character}. Should each silhouette be aligned to its
#'   respective tip (`"tip"`, the default) or to the right-hand side of the
#'   plotting area (`"plot"`)? If `"tip"` is specified, the silhouette is placed
#'   at the x coordinate of the respective tip, plus any horizontal padding
#'   specified by `padding` or `relPadding`. If `"plot"` is specified, the
#'   silhouette is placed at the right-hand side of the plotting area,
#'   determined by `par("usr")`, plus any horizontal padding specified by
#'   `padding` or `relPadding`.
#' @param width,relWidth `numeric`. The width of each silhouette, in the plot coordinate
#'   system (`width`) or relative to the size of the plotting area (`relWidth`).
#'   If "NULL" and `height` is specified, the width is determined by the aspect
#'   ratio of the original image. One of height and width must be "NULL".
#' @param padding,relPadding `numeric`. Horizontal padding for each silhouette from its
#'   respective x value, in the plot coordinate system (`padding`) or relative
#'   to the size of the plotting area (`relPadding`). Negative values offset to
#'   the left.
#' @param \dots Further arguments to pass to [add_phylopic_base()].
#' @author [Martin R. Smith](https://orcid.org/0000-0001-5660-1727)
#'   (<martin.smith@durham.ac.uk>)
#' @seealso For trees plotted using \pkg{ggtree}, see [`geom_phylopic()`].
#' @importFrom ape plot.phylo .PlotPhyloEnv
#' @importFrom grDevices dev.cur
#' @export
#' @examples \dontrun{
#' # Load the ape library to work with phylogenetic trees
#' library("ape")
#' 
#' # Read a phylogenetic tree
#' tree <- ape::read.tree(text = "(cat, (dog, mouse));")
#' 
#' # Set a large right margin to accommodate the silhouettes
#' par(mar = c(1, 1, 1, 10))
#' 
#' # Plot the tree
#' plot(tree)
#' 
#' # Add a PhyloPic silhouette of a cat to the tree
#' add_phylopic_tree(
#'   tree, # Must be the tree that was plotted
#'   "cat", # Which leaf should the silhouette be plotted against?
#'   uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9", # Silhouette to plot
#'   relWidth = 0.2,
#'   fill = "brown"
#' )
#' }
add_phylopic_tree <- function(tree, tip = names(img) %||% names(uuid) %||%
                                names(name) %||% name,
                              img = NULL,
                              name = if (is.null(img) && is.null(uuid)) tip 
                                else NULL,
                              uuid = NULL, align = "tip",
                              width, padding = NULL,
                              relWidth = 0.06,
                              relPadding = if(align == "tip") 1/200 else -1/200,
                              hjust = if(align == "tip") 0 else 1,
                              ...) {
  align <- match.arg(align, c("tip", "plot"))
  if (dev.cur() < 2) {
    # It would be nice to check whether the plotting device that contains
    # last_plot.phylo is still the active device, but this is not possible - so
    # we leave the responsibility of calling the function sensibly to the user.
    stop("No plotting device is open; try plot(tree)")
  }
  tipLabels <- tree[["tip.label"]]
  leafIndex <- match(tip, tipLabels)
  leafMissing <- is.na(leafIndex)
  if (any(leafMissing)) {
    nearMiss <- unlist(lapply(tip[leafMissing], agrep, tipLabels,
                              max.distance = 0.5), use.names = FALSE,
                       recursive = FALSE)
    stop("Could not find '", paste(tip[leafMissing], collapse = "', '"),
                                   "' in tree$tip.label.  ",
         if (length(nearMiss)) {
           paste0("Did you mean '",
                  paste(tipLabels[nearMiss], collapse = "', '"), "'?")
         })
  }
  coords <- tryCatch(get("last_plot.phylo", envir = .PlotPhyloEnv),
                     error = function(e) {
                       stop("plot(tree) has not been called")
                     })
  rightEdge <- par("usr")[[2]]
  leftEdge <- par("usr")[[1]]
  plotWidth <- rightEdge - leftEdge
  if (missing(width)) {
    width <- plotWidth * relWidth
  }
  padX <- padding %||% relPadding * plotWidth
  add_phylopic_base(
    img = img,
    name = name,
    uuid = uuid,
    x = switch(align,
               tip = coords[["xx"]][leafIndex],
               plot = rightEdge) + padX,
    y = coords[["yy"]][leafIndex],
    hjust = hjust,
    width = width,
    ...
  )
}
