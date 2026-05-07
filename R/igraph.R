rphylopic.igraph <- function(coords, v = NULL, params) {
  # get plotting parameters and get index if necessary
  vertex.alpha <- params("vertex", "alpha")
  if (length(vertex.alpha) != 1 && !is.null(v)) {
    vertex.alpha <- vertex.alpha[v]
  }
  vertex.color <- params("vertex", "color")
  if (length(vertex.color) != 1 && !is.null(v)) {
    vertex.color <- vertex.color[v]
  }
  vertex.frame.color <- params("vertex", "frame.color")
  if (length(vertex.frame.color) != 1 && !is.null(v)) {
    vertex.frame.color <- vertex.frame.color[v]
  }
  vertex.size <- params("vertex", "size")
  if (length(vertex.size) != 1 && !is.null(v)) {
    vertex.size <- vertex.size[v]
  }
  vertex.horizontal <- params("vertex", "horizontal")
  if (length(vertex.horizontal) != 1 && !is.null(v)) {
    vertex.horizontal <- vertex.horizontal[v]
  }
  vertex.vertical <- params("vertex", "vertical")
  if (length(vertex.vertical) != 1 && !is.null(v)) {
    vertex.vertical <- vertex.vertical[v]
  }
  vertex.angle <- params("vertex", "angle")
  if (length(vertex.angle) != 1 && !is.null(v)) {
    vertex.angle <- vertex.angle[v]
  }
  vertex.hjust <- params("vertex", "hjust")
  if (length(vertex.hjust) != 1 && !is.null(v)) {
    vertex.hjust <- vertex.hjust[v]
  }
  vertex.vjust <- params("vertex", "vjust")
  if (length(vertex.vjust) != 1 && !is.null(v)) {
    vertex.vjust <- vertex.vjust[v]
  }
  # only one of these three should be specified
  img <- params("vertex", "img")
  if (length(img) != 1 && !is.null(v)) {
    img <- img[v]
  }
  name <- params("vertex", "name")
  if (length(name) != 1 && !is.null(v)) {
    name <- name[v]
  }
  uuid <- params("vertex", "uuid")
  if (length(uuid) != 1 && !is.null(v)) {
    uuid <- uuid[v]
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

register_phylopic_shape <- function() {
  igraph::add_shape("phylopic",
                    clip = igraph::shape_noclip,
                    plot = rphylopic.igraph,
                    parameters = list(
                      vertex.img = NULL,
                      vertex.name = NULL,
                      vertex.uuid = NULL,
                      vertex.alpha = 1,
                      vertex.color = "black",
                      vertex.frame.color = NA,
                      vertex.size = 20,
                      vertex.horizontal = FALSE,
                      vertex.vertical = FALSE,
                      vertex.angle = 0,
                      vertex.hjust = 0.5,
                      vertex.vjust = 0.5,
                      vertex.filter = NULL,
                      vertex.remove_background = TRUE,
                      vertex.verbose = FALSE
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
#' }
#'
#' @examples
#' \dontrun{
#' library(igraph)
#' g <- make_ring(10)
#' plot(g, vertex.shape = "phylopic", vertex.name = "Gorilla",
#'      vertex.color = rainbow(vcount(g)))
#' }
#' @seealso [add_phylopic_base()], [igraph::add_shape()]
#' @name phylopic_igraph
NULL
