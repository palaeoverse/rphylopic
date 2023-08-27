#' Add a PhyloPic legend for a base R plot
#'
#' Specify existing images, taxonomic names, or PhyloPic uuids to add PhyloPic
#' silhouettes as a legend to an existing base R plot (like [legend()]).
#'
#' @param img A [Picture][grImport2::Picture-class] or png array object, e.g.,
#'   from using [get_phylopic()].
#' @param name \code{character}. A taxonomic name to be passed to [get_uuid()].
#' @param uuid \code{character}. A valid uuid for a PhyloPic silhouette (such as
#'   that returned by [get_uuid()] or [pick_phylopic()]).
#' @param ysize \code{numeric}. Height of the silhouette(s). The width is
#'   determined by the aspect ratio of the original image.
#' @param ... Additional arguments passed to [legend()].
#'   
#' @details
#' Additional details...
#' @export
#' @examples
#' 
add_phylopic_legend <- function(img = NULL, name = NULL, uuid = NULL, 
                                ysize = NULL, ...) {
  leg_pos <- legend(...)
  x <- leg_pos$text$x * 0.95
  y <- leg_pos$text$y
  # convert x, y, to normalized device coordinates
  # x <- grconvertX(x, to = "ndc")
  # y <- grconvertY(y, to = "ndc")
  add_phylopic_base(uuid = uuid,
                    x = x, 
                    y = y, 
                    ysize = ysize)
}

uuids <- get_uuid(name = "Canis lupus", n = 2)

plot(0:10, 0:10, type = "n", main = "Wolfs")
add_phylopic_base(uuid = uuids,
                  x = c(2.5, 7.5), y = c(2.5, 7.5), ysize = 2)
add_phylopic_legend(uuid = uuids,
                x = 8, y = 8, legend = c("Wolf 1", "Wolf 2"),
                ysize = 0.5)







# single image
plot(1, 1, type = "n", main = "A cat")
add_phylopic_base(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
                  x = 1, y = 1, ysize = 0.4)

test <- legend("topright", c("Cat"),
               pch = NULL)

add_phylopic_base(uuid = "23cd6aa4-9587-4a2e-8e26-de42885004c9",
                  x = test$text$x/1.025, y = test$text$y, ysize = 0.05)


legend_phylopic <- function(img = NULL, name = NULL, uuid = NULL, size = 0.1, ...) {
  leg_pos <- legend(...)
  add_phylopic_base(uuid = uuid,
                    x = leg_pos$text$x/1.05, 
                    y = leg_pos$text$y, 
                    ysize = size)
}


