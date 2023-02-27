#' Pick a PhyloPic image from available options
#'
#' This function provides a visually interactive way to pick an image and
#' valid uuid for an input taxonomic name. As multiple silhouettes can exist
#' for each species in PhyloPic, this function is useful for choosing the 
#' right image/uuid for the user.
#'
#' @param name \code{character}. A taxonomic name. Different taxonomic levels
#'   are supported (e.g. species, genus, family).
#' @param n \code{numeric}. How many uuids should be viewed? Depending on
#'   the requested `name`, multiple silhouettes may exist. If `n` exceeds
#'   the number of available images, all available uuids will be returned.
#'   Defaults to 5.
#'
#' @return A \code{Picture} object is returned. The uuid of the selected
#'   image is also printed to console.
#' 
#' @details This function allows the user to visually select the desired
#'   image from a pool of silhouettes available for the input `name`.
#' 
#' @importFrom grid grid.newpage grid.text
#' @importFrom grImport2 grid.picture
#' 
#' @export
#' @examples 
#' img <- pick_phylo(name = "Canis lupus", n = 5)
pick_phylo <- function(name = NULL, n = 5){
  # Get uuids
  uuids <- get_uuid(name = name, n = n, url = FALSE)
  # Cycle through uuids
  for (i in seq_along(uuids)) {
    # Start a new graphics page
    grid.newpage()
    # Get image data
    img <- image_data(uuid = uuids[i], size = "vector")
    # Get attribution data
    att <- get_attribution(uuid = uuids[i])
    # Plot image
    grid.picture(img)
    # Add text for attribution
    att_string <- paste0("Contributor: ", att$contributor, "\n",
                         "Created: ", att$created, "\n",
                         "License: ", att$license)
    grid.text(label = att_string, 
              x = 0.96, y = 0.92,
              just = "right",
              gp = gpar(fontsize = 8, col = "purple", fontface = "bold"))
    # Return data for final image
    if (i == length(uuids)) {
      message("This is the only or final image. Returning this uuid data.")
      print(uuids[i])
      return(img)
    }
    # Set up menu choice
    m <- menu(choices = c("Next", "Select"), title = paste0(
      "Choose an option (", i, "/", length(uuids), "):"))
    # Make selection
    if (m == 2) {
      print(uuids[i])
      return(img)
    }
  }
}
