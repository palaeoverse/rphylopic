#' Pick a PhyloPic image from available options
#'
#' This function provides a visually interactive way to pick an image and
#' valid uuid for an input taxonomic name. As multiple silhouettes can exist
#' for each organism in PhyloPic, this function is useful for choosing the
#' right image/uuid for the user.
#'
#' @param name \code{character}. A taxonomic name. Different taxonomic levels
#'   are supported (e.g. species, genus, family).
#' @param n \code{numeric}. How many uuids should be viewed? Depending on the
#'   requested `name`, multiple silhouettes may exist. If `n` exceeds the
#'   number of available images, all available uuids will be returned.
#'   Defaults to 5.
#' @param ncol \code{numeric}. Number of columns in the plot grid (default:
#'   1). The number of silhouettes plotted at once is the product of `ncol`
#'   and `nrow`.
#' @param nrow \code{numeric}. Number of rows in the plot grid (default: 1).
#'   The number of silhouettes plotted at once is the product of `ncol` and
#'   `nrow`.
#' @param auto \code{numeric}. This argument allows the user to automate input
#'   into the menu choice. If the input value is `1`, the first returned image 
#'   will be selected. If the input value is `2`, requested images will be
#'   automatically cycled through with the final image returned. If `NULL`
#'   (default), the user must interactively respond to the called menu.
#'
#' @return A [Picture][grImport2::Picture-class] object is returned. The uuid
#'   of the selected image is saved as the "uuid" attribute of the returned
#'   object and is also printed to console.
#'
#' @details This function allows the user to visually select the desired image
#'   from a pool of silhouettes available for the input `name`.
#'
#' @importFrom grid grid.newpage grid.text
#' @importFrom grImport2 grid.picture grobify
#' @importFrom utils menu
#' @importFrom ggpubr ggarrange
#' @export
#' @examples \dontrun{
#' # Defaults pane layout
#' img <- pick_phylopic(name = "Canis lupus", n = 5)
#' # 3 x 3 pane layout
#' img <- pick_phylopic(name = "Scleractinia", n = 9, ncol = 3, nrow = 3)
#' }
pick_phylopic <- function(name = NULL, n = 5, ncol = 1, nrow = 1, auto = NULL) {
  # Error handling
  if (!is.null(auto) && !auto %in% c(1, 2)) {
    stop("`auto` must be of value: NULL, 1, or 2")
  }
  if (!is.numeric(ncol) || !is.numeric(nrow)) {
    stop("`ncol` and `nrow` must be of class numeric.")
  }
  
  # Internal function for plotting selected image
  return_img <- function(uuids) {
    img <- get_phylopic(uuid = uuids)
    att <- get_attribution(uuid = uuids)
    print(uuids)
    grid.newpage()
    grid.picture(img)
    # Add text for attribution
    att_string <- paste0("Contributor: ", att$contributor, "\n",
                         "Created: ", att$created, "\n",
                         "License: ", att$license)
    grid.text(label = att_string,
              x = 0.96, y = 0.92,
              just = "right",
              gp = gpar(fontsize = 8, col = "purple", fontface = "bold"))
    return(img)
  }

  # Get uuids
  uuids <- get_uuid(name = name, n = n, url = FALSE)
  # Record length
  n_uuids <- length(uuids)
  
  # Return data if only one image requested
  if (n == 1) {
    img <- return_img(uuids = uuids)
    return(img)
  }
  
  # Return data if only one image
  if (n_uuids == 1) {
    message("This is the only image. Returning this uuid data.")
    img <- return_img(uuids = uuids)
    return(img)
  }
  
  # Generate list of uuids for batch viewing
  # How many silhouettes should be plotted at once?
  batch <- prod(ncol, nrow)
  
  # Suppress warnings when there is an uneven split
  if ((length(uuids) %% batch) != 0) {
    uuids <- suppressWarnings(
      split(x = uuids, f = ceiling(seq_along(uuids) / batch)))
  } else {
    uuids <- split(x = uuids, f = ceiling(seq_along(uuids) / batch))
  }
  
  # Cycle through list
  for (i in seq_along(uuids)) {
    # Get image data
    img <- sapply(uuids[[i]], get_phylopic)
    # Get attribution data
    att <- lapply(uuids[[i]], get_attribution)
    # Attribution text
    att_string <- lapply(att, function(x){
      paste0(x$contributor, " (", x$created, "). License: ", x$license)
    })
    att_string <- unlist(att_string)
    
    # Set up menu
    if (is.null(auto)) {
      # Grobify images
      img <- lapply(img, grobify)
      # Plot image choices
      print(ggarrange(plotlist = img, nrow = nrow, ncol = ncol, 
                      labels = 1:length(img)))
      m <- menu(choices = c(att_string, "Next"), title = paste0(
        "Choose an option (", i, "/", ceiling(n_uuids / batch), " pages):"))
    } else {
      # Select final uuid
      if (auto == 2) {
        # Update i (final batch)
        i <- length(uuids)
        # Update m  to 'next' valye (force final image of final batch)
        n_plotted <- length(uuids[[i]])
        m <- n_plotted + 1
      } else if (auto == 1) {
        m <- 1
      }
    }
    
    # Make selection
    n_plotted <- length(uuids[[i]])
    if (m != (n_plotted + 1)) {
      uuids <- uuids[[i]][m]
      img <- return_img(uuids = uuids)
      return(img)
    }
    
    # If final image available reached, return
    if (i == length(uuids)) {
      message("This is the final image. Returning this uuid data.")
      uuids <- uuids[[i]][n_plotted]
      img <- return_img(uuids = uuids)
      return(img)
    }
  }
}
