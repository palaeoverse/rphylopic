rphylopic.igraph <- function(coords, v = NULL, params) {
  # get plotting parameters and get index if necessary
  vertex.alpha <- params("vertex", "alpha")
  if (length(vertex.alpha) != 1 && !is.null(v)) {
    vertex.alpha <- vertex.alpha[v] # nocov
  }
  vertex.color <- params("vertex", "color")
  if (length(vertex.color) != 1 && !is.null(v)) {
    vertex.color <- vertex.color[v] # nocov
  }
  vertex.frame.color <- params("vertex", "frame.color")
  if (length(vertex.frame.color) != 1 && !is.null(v)) {
    vertex.frame.color <- vertex.frame.color[v] # nocov
  }
  vertex.size <- params("vertex", "size")
  if (length(vertex.size) != 1 && !is.null(v)) {
    vertex.size <- vertex.size[v] # nocov
  }
  vertex.horizontal <- params("vertex", "horizontal")
  if (length(vertex.horizontal) != 1 && !is.null(v)) {
    vertex.horizontal <- vertex.horizontal[v] # nocov
  }
  vertex.vertical <- params("vertex", "vertical")
  if (length(vertex.vertical) != 1 && !is.null(v)) {
    vertex.vertical <- vertex.vertical[v] # nocov
  }
  vertex.angle <- params("vertex", "angle")
  if (length(vertex.angle) != 1 && !is.null(v)) {
    vertex.angle <- vertex.angle[v] # nocov
  }
  vertex.hjust <- params("vertex", "hjust")
  if (length(vertex.hjust) != 1 && !is.null(v)) {
    vertex.hjust <- vertex.hjust[v] # nocov
  }
  vertex.vjust <- params("vertex", "vjust")
  if (length(vertex.vjust) != 1 && !is.null(v)) {
    vertex.vjust <- vertex.vjust[v] # nocov
  }
  # only one of these three should be specified
  img <- params("vertex", "img")
  if (length(img) != 1 && !is.null(v)) {
    img <- img[v] # nocov
  }
  name <- params("vertex", "name")
  if (length(name) != 1 && !is.null(v)) {
    name <- name[v] # nocov
  }
  uuid <- params("vertex", "uuid")
  if (length(uuid) != 1 && !is.null(v)) {
    uuid <- uuid[v] # nocov
  }
  add_phylopic_base(img = img, name = name, uuid = uuid,
                    x = coords[, 1], y = coords[, 2], height = vertex.size,
                    alpha = vertex.alpha, color = vertex.frame.color,
                    fill = vertex.color,
                    horizontal = vertex.horizontal, vertical = vertex.vertical,
                    angle = vertex.angle,
                    hjust = vertex.hjust, vjust = vertex.vjust,
                    remove_background = params("vertex", "remove_background"),
                    verbose = params("vertex", "verbose"),
                    filter = params("vertex", "filter"))
}

phylopic_clip <- function(coords, el, params, end = c("both", "from", "to")) {
  clip_scale <- params("vertex", "clip_scale")
  # Fall back to default if entirely unset, otherwise patch NAs in place
  if (length(clip_scale) == 0) {
    clip_scale <- 0.7
  } else {
    clip_scale[is.na(clip_scale)] <- 0.7
  }
  
  # Wrap igraph's circle clip with a scaled-down vertex.size so arrows stop
  # at roughly the silhouette outline rather than its bounding circle
  scaled_params <- function(type, name) {
    val <- params(type, name)
    if (type == "vertex" && name == "size") val * clip_scale else val
  }
  igraph::shapes("circle")$clip(coords, el, scaled_params, end)
}

register_phylopic_shape <- function() {
  igraph::add_shape("phylopic",
                    clip = phylopic_clip,
                    plot = rphylopic.igraph,
                    parameters = list(
                      vertex.img = NULL,
                      vertex.name = NULL,
                      vertex.uuid = NULL,
                      vertex.alpha = 1,
                      vertex.color = "black",
                      vertex.frame.color = NA,
                      vertex.size = 40,
                      vertex.horizontal = FALSE,
                      vertex.vertical = FALSE,
                      vertex.angle = 0,
                      vertex.hjust = 0.5,
                      vertex.vjust = 0.5,
                      vertex.filter = NULL,
                      vertex.remove_background = TRUE,
                      vertex.verbose = FALSE,
                      vertex.clip_scale = 0.7
                    )
  )
}

#' Use PhyloPic silhouettes with igraph
#'
#' @description
#' When both `rphylopic` and `igraph` are loaded, rphylopic registers a
#' custom vertex shape called `"phylopic"`. Setting `vertex.shape = "phylopic"`
#' in [igraph::plot.igraph()] renders each vertex as a PhyloPic silhouette.
#'
#' @details
#' The shape accepts the following vertex parameters, mirroring the
#' arguments of [add_phylopic_base()]:
#'
#' \itemize{
#'   \item `vertex.img`, `vertex.name`, `vertex.uuid` — silhouette source
#'   \item `vertex.size` — silhouette height (in plot units)
#'   \item `vertex.color`, `vertex.frame.color`, `vertex.alpha` — fill, outline,
#'     opacity
#'   \item `vertex.horizontal`, `vertex.vertical`, `vertex.angle` — orientation
#'   \item `vertex.hjust`, `vertex.vjust` — anchoring
#'   \item `vertex.remove_background`, `vertex.verbose`, `vertex.filter` —
#'     passed to [add_phylopic_base()]
#'   \item `vertex.clip_scale` — numeric scale factor controlling the clipping
#'     of the edges (default: `0.7`)
#' }
#' 
#' @section Note on interactive resizing:
#' PhyloPic silhouettes are drawn as vector graphics on top of igraph's
#' base-graphics plot. Rendering as vectors preserves silhouette resolution;
#' however, when the graphics device is resized interactively the silhouettes
#' will not reposition along with the underlying graph layout. The graph nodes,
#' edges, and labels will redraw at their new coordinates while the
#' silhouettes remain anchored to their original device positions. To
#' restore alignment, re-run your `plot(...)` call after resizing.
#'
#' @examples
#' \dontrun{
#' library(igraph)
#' library(rphylopic)
#' g <- make_ring(10)
#' plot(g, vertex.shape = "phylopic", vertex.name = "Gorilla",
#'      vertex.color = rainbow(vcount(g)))
#' }
#' @seealso [add_phylopic_base()], [igraph::add_shape()]
#' @name phylopic_igraph
NULL
