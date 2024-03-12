## declare variables that are used within aes() to prevent
## R CMD check from complaining
utils::globalVariables(c("x", "y", "uuid", "label"))

#' Pick a PhyloPic image from available options
#'
#' This function provides a visually interactive way to pick an image and valid
#' uuid for an input taxonomic name. As multiple silhouettes can exist for each
#' organism in PhyloPic, this function is useful for choosing the right
#' image/uuid for the user.
#'
#' @param name \code{character}. A taxonomic name. Different taxonomic levels
#'   are supported (e.g. species, genus, family).
#' @param n \code{numeric}. How many uuids should be viewed? Depending on the
#'   requested `name`, multiple silhouettes may exist. If `n` exceeds the number
#'   of available images, all available uuids will be returned. Defaults to 5.
#'   Only relevant if `name` supplied.
#' @param uuid \code{character}. A vector (or list) of valid PhyloPic 
#'   silhouette uuids, such as that returned by [get_uuid()] or
#'   [resolve_phylopic()].
#' @param view \code{numeric}. Number of silhouettes that should be plotted at
#'   the same time. Defaults to 1.
#' @param filter \code{character}. Filter uuid(s) by usage license. Use "by"
#'   to limit results to image uuids which do not require attribution, "nc"
#'   for image uuids which allow commercial usage, and "sa" for image uuids
#'   without a ShareAlike clause. The user can also combine these filters. Only
#'   relevant if `name` supplied.
#' @param auto \code{numeric}. This argument allows the user to automate input
#'   into the menu choice. If the input value is `1`, the first returned image
#'   will be selected. If the input value is `2`, requested images will be
#'   automatically cycled through with the final image returned. If the input
#'   value is `3`, a list of attribution information for each image is 
#'   returned (this functionality is principally intended for testing). If 
#'   `NULL` (default), the user must interactively respond to the called menu.
#'
#' @return A [Picture][grImport2::Picture-class] object is returned. The uuid of
#'   the selected image is saved as the "uuid" attribute of the returned object
#'   and is also printed to console.
#'
#' @details This function allows the user to visually select the desired image
#'   from a pool of silhouettes available for the input `name`.
#'
#'   Note that while the `view` argument can be any positive integer,
#'   weaker/older computers may have issues displaying very large numbers of
#'   images at the same time (i.e. `view` > 9). If no images are displayed in
#'   your plotting environment, try decreasing the value of `view`.
#'
#' @importFrom grid grid.newpage grid.text gpar
#' @importFrom grImport2 grid.picture
#' @importFrom utils menu
#' @importFrom ggplot2 ggplot facet_wrap theme theme_void
#' @importFrom ggplot2 coord_equal
#' @importFrom ggplot2 element_text expansion
#' @importFrom pbapply pblapply
#' @export
#' @examples \dontrun{
#' # Defaults pane layout
#' img <- pick_phylopic(name = "Canis lupus", n = 5)
#' # 3 x 3 pane layout
#' img <- pick_phylopic(name = "Scleractinia", n = 9, view = 9)
#' }
pick_phylopic <- function(name = NULL, n = 5, uuid = NULL, view = 1,
                          filter = NULL, auto = NULL) {
  # Error handling
  if (!is.null(auto) && !auto %in% c(1, 2, 3)) {
    stop("`auto` must be of value: NULL, 1, 2, or 3")
  }
  if (!is.numeric(view)) {
    stop("`view` must be of class numeric.")
  }

  # Internal function for plotting selected image
  return_img <- function(uuid) {
    img <- get_phylopic(uuid = uuid)
    att <- get_attribution(uuid = uuid)
    print(uuid)
    grid.newpage()
    grid.picture(img)
    # Add text for attribution
    att <- att[[1]][[1]]
    att_string <- paste0("Contributor: ", att$contributor, "\n",
                         "Created: ", att$created, "\n",
                         "Attribution: ", att$attribution, "\n",
                         "License: ", att$license)
    grid.text(label = att_string,
              x = 0.96, y = 0.92,
              just = "right",
              gp = gpar(fontsize = 8, col = "purple", fontface = "bold"))
    return(img)
  }
  
  if (is.null(uuid)) {
    # Get uuids
    uuids <- get_uuid(name = name, n = n, filter = filter, url = FALSE)
  } else {
    uuids <- unlist(uuid)
  }
  # Record length
  n_uuids <- length(uuids)

  # Return data if only one image requested
  if (n == 1) {
    img <- return_img(uuid = uuids)
    return(img)
  }

  # Return data if only one image exists
  if (n_uuids == 1) {
    message("This is the only image. Returning this uuid data.")
    img <- return_img(uuid = uuids)
    return(img)
  }

  # Suppress warnings when there is an uneven split
  if ((length(uuids) %% view) != 0) {
    uuids <- suppressWarnings(split(x = uuids,
                                    f = ceiling(seq_along(uuids) / view)))
  } else {
    uuids <- split(x = uuids, f = ceiling(seq_along(uuids) / view))
  }

  # Cycle through list
  for (i in seq_along(uuids)) {
    # Get image data
    height <- 1024 / ceiling(sqrt(view))
    if (view > 1 && length(uuids[[i]]) > 1) {
      img <- pblapply(uuids[[i]], get_phylopic, format = "raster", height)
    } else {
      img <- sapply(uuids[[i]], get_phylopic)
    }
    # Get attribution data
    att <- lapply(uuids[[i]], get_attribution)
    att <- lapply(att, function(x) x[[1]][[1]])
    # Attribution text
    n_spaces <- 3 + floor(log10(length(att) + 1))
    att_string <- lapply(att, function(x) {
      paste0(x$contributor, " (", x$created, ").\n", strrep(" ", n_spaces),
             "License: ", x$license)
    })
    att_string <- unlist(att_string)

    # Set up menu
    if (is.null(auto)) {
      # Set up plotting dataframe
      df <- data.frame(x = 0.5, y = 0.5, uuid = uuids[[i]],
                       label = seq_len(length(uuids[[i]])))
      if (view > 1) {
        dims <- sapply(img, dim)
        df$size <- sapply(height / dims[2, ], min, 1)
      } else {
        df$size <- 1
      }
      # Set factor levels to ensure consistent plotting order
      df$uuid <- factor(x = df$uuid, levels = df$uuid)
      df$img <- img
      # Plot silhouettes
      p <- ggplot(data = df) +
        geom_phylopic(aes(x = x, y = y, img = img),
                      size = df$size,
                      color = "original") +
        facet_wrap(~label) +
        coord_equal(xlim = c(0, 1), ylim = c(0, 1)) +
        theme_void() +
        theme(strip.text = element_text(face = "bold",
                                        size = 11,
                                        color = "purple"))
      print(p)
      m <- menu(choices = c(att_string, "Next"),
                title = paste0("Choose an option (", i, "/",
                               ceiling(n_uuids / view), " pages):"))
      if (m == 0) return()
    } else {
      # Select final uuid
      if (auto == 2) {
        # Update i (final batch)
        i <- length(uuids)
        # Update m  to 'next' value (force final image of final batch)
        n_plotted <- length(uuids[[i]])
        m <- n_plotted + 1
      } else if (auto == 1) {
        m <- 1
      } else if (auto == 3) {
        names(att) <- sapply(att, function(x) x$image_uuid)
        return(att)
      }
    }

    # Make selection
    n_plotted <- length(uuids[[i]])
    if (m != (n_plotted + 1)) {
      uuid <- uuids[[i]][m]
      img <- return_img(uuid = uuid)
      return(img)
    }

    # If final image available reached, return
    if (i == length(uuids)) {
      message("This is the final image. Returning this uuid data.")
      uuid <- uuids[[i]][n_plotted]
      img <- return_img(uuid = uuid)
      return(img)
    }
  }
}
