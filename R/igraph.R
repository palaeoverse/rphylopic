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
  vertex.size <- 1 / 200 * params("vertex", "size")
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
                    remove_background = params("vertex", "verbose"),
                    verbose = params("vertex", "verbose"))
}

#' Use PhyloPics with igraph
#' 
#' This function adds a new vertex shape ("phylopic") to igraph that allows you
#' to use PhyloPics in your igraph plots. It sets up the necessary parameters
#' (see Details below) and registers the shape with igraph.
#' 
#' @details Additional details...
#' 
#' @importFrom igraph add_shape
#' @importFrom igraph shape_noclip
#' @importFrom rlang check_installed
#' @export
#' @examples \dontrun{
#' # load igraph and activate the connection with rphylopic
#' library(igraph)
#' activate_igraph()
#' # create a simple graph
#' g <- make_ring(10)
#' # plot the graph with phylopics
#' plot(g, vertex.shape = "phylopic", vertex.color = rainbow(vcount(g)),
#'      vertex.name = "Gorilla")
#' }
activate_igraph <- function() {
  check_installed("igraph", reason = "to use `rphylopic_igraph_activate()`")
  add_shape("phylopic",
            clip = shape_noclip,
            plot = rphylopic.igraph,
            parameters = list(
              vertex.img = NULL,
              vertex.name = NULL,
              vertex.uuid = NULL,
              vertex.filter = NULL,
              vertex.alpha = 1,
              vertex.color = "black",
              vertex.frame.color = NA,
              vertex.size = 20,
              vertex.horizontal = FALSE,
              vertex.vertical = FALSE,
              vertex.angle = 0,
              vertex.hjust = 0.5,
              vertex.vjust = 0.5,
              vertex.remove_background = TRUE,
              vertex.verbose = FALSE
            )
  )
}
