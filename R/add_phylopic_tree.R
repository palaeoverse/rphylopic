#' Add PhyloPics to a plotted phylogenetic tree
#'
#' Specify existing images, taxonomic names, or PhyloPic uuids to add PhyloPic
#' silhouettes alongside the associated leaves of a phylogenetic tree.
#'
#' @inheritParams add_phylopic
#' @param tree The phylogenetic tree object of class `phylo` on which to add
#' the silhouette.
#' @param tip The tip labels against which to add the silhouettes.
#' @param relWidth The width of each silhouette relative to the plotting area.
#' @param padding Distance to inset each silhouette from the right edge of the
#' plotting area, relative to the size of the plotting area.
#' Negative values offset to the right.
#' @param \dots Further arguments to pass to `add_phylopic_base()`..
#' @author [Martin R. Smith](https://orcid.org/0000-0001-5660-1727) 
#' (<martin.smith@durham.ac.uk>)
#' @importFrom ape plot.phylo .PlotPhyloEnv
#' @export
#' @examples \dontrun{
#'  # Load the ape library to work with phylogenetic trees
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
add_phylopic_tree <- function(tree, tip, img = NULL,
                              name = if (is.null(img) && is.null(uuid)) tip 
                                else NULL, 
                              uuid = NULL, width, relWidth = 0.06,
                              padding = 1/200,
                              hjust = 0,
                              ...) {
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
                       plot(tree)
                       get("last_plot.phylo", envir = .PlotPhyloEnv)
                     })
  rightEdge <- par("usr")[[2]]
  leftEdge <- par("usr")[[1]]
  plotWidth <- rightEdge - leftEdge
  if (missing(width)) {
    width <- plotWidth * relWidth
  }
  padX <- padding * plotWidth
  add_phylopic_base(
    img = img,
    name = name,
    uuid = uuid,
    x = rightEdge - width - padX,
    y = coords[["yy"]][leafIndex],
    hjust = hjust,
    width = width,
    ...
  )
}
