#' Pick a PhyloPic uuid from available options
#'
#' This function provides a visually interactive way to pick a valid uuid
#' for an input taxonomic name. As multiple silhouettes can exist for each
#' species in PhyloPic, this is useful for choosing the right uuid for you.
#'
#' @param name \code{character}. A taxonomic name. Different taxonomic levels
#'   are supported (e.g. species, genus, family).
#' @param n \code{numeric}. How many uuids should be returned? Depending
#' on the requested `name`, multiple silhouettes might exist. If `n` exceeds
#' the number of available images, all available uuids will be returned. This
#' argument defaults to 1. 
#' @param url \code{logical}. If \code{FALSE} (default), only the uuid is
#'   returned. If \code{TRUE}, a valid PhyloPic image url of the uuid is
#'   returned.
#'
#'
#'
#'
#'
#'
#'
#'
pick_phylo <- function(name, n = 5, url = FALSE){
  # Get uuids
  uuids <- get_uuid(name = name, n = n, url = url)
  # Cycle through uuids
  for (i in uuids) {
    img <- image_data(uuid = i, size = "vector")
    grid.picture(img)
    m <- menu(choices = c("Next", "Select"), title = "Choose an option:")
    if (m == 2) {
      print(i)
      return(img)
    }
    dev.off()
  }
}


