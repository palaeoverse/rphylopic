#' Geom for adding PhyloPic silhouettes to a plot
#'
#' This geom acts like [ggplot2::geom_point()], except the specified silhouettes
#' are used as points. Silhouettes can be specified by `name` strings, `uuid`
#' strings, or image objects (`img`).
#'
#' @details One (and only one) of the `img`, `name`, or `uuid` aesthetics must
#'   be specified. The `img` aesthetic can be
#'   [Picture][grImport2::Picture-class] objects or png array objects, e.g.,
#'   from using [get_phylopic()]. Use the `x` and `y` aesthetics to place the
#'   silhouettes at specified positions on the plot. The `size` aesthetic
#'   specifies the height of the silhouettes in the units of the y axis. The
#'   aspect ratio of the silhouettes will always be maintained.
#'
#'   The `alpha` and `color` aesthetics can be used to change the transparency
#'   and color of the silhouettes, respectively. The `horizontal` and `vertical`
#'   aesthetics can be used to flip the silhouettes. The `angle` aesthetic can
#'   be used to rotate the silhouettes.
#'
#'   When specifying a horizontal and/or vertical flip **and** a rotation, the
#'   flip(s) will always occur first. If you would like to customize this
#'   behavior, you can flip and/or rotate the image within your own workflow
#'   using [flip_phylopic()] and [rotate_phylopic()].
#'
#'   Note that png array objects can only be rotated by multiples of 90 degrees.
#'
#' @param show.legend logical. Should this layer be included in the legends?
#'   `FALSE`, the default, never includes, `NA` includes if any aesthetics are
#'   mapped, and `TRUE` always includes. It can also be a named logical vector
#'   to finely select the aesthetics to display.
#' @inheritParams ggplot2::layer
#' @inheritParams ggplot2::geom_point
#' @importFrom ggplot2 layer
#' @export
#' @examples
#' library(ggplot2)
#' df <- data.frame(x = 2:5, y = seq(10, 25, 5),
#'                  name = c("cat", "walrus", "house mouse", "iris"))
#' ggplot(df) +
#'   geom_phylopic(aes(x = x, y = y, name = name),
#'                 color = "purple", size = 10) +
#'   facet_wrap(~name) +
#'   coord_cartesian(xlim = c(1,6), ylim = c(5, 30))
geom_phylopic <- function(mapping = NULL, data = NULL,
                          stat = "identity", position = "identity",
                          ...,
                          na.rm = FALSE,
                          show.legend = FALSE,
                          inherit.aes = TRUE) {
  layer(
    data = data,
    mapping = mapping,
    stat = stat,
    geom = GeomPhylopic,
    position = position,
    show.legend = show.legend,
    inherit.aes = inherit.aes,
    params = list(
      na.rm = na.rm,
      ...
    )
  )
}

#' @importFrom ggplot2 ggproto Geom aes
#' @importFrom grid gTree gList nullGrob
GeomPhylopic <- ggproto("GeomPhylopic", Geom,
  required_aes = c("x", "y"),
  non_missing_aes = c("size", "alpha", "color",
                      "horizontal", "vertical", "angle"),
  optional_aes = c("img", "name", "uuid"), # one and only one of these
  default_aes = aes(size = 1.5, alpha = 1, color = "black",
                    horizontal = FALSE, vertical = FALSE, angle = 0),
  draw_panel = function(self, data, panel_params, coord) {
    data <- coord$transform(data, panel_params)
    # Check aesthetics are valid
    if (any(data$alpha > 1 | data$alpha < 0)) {
      stop("`alpha` must be between 0 and 1.")
    }
    # Check that only one silhouette aesthetic exists
    cols <- sapply(c("img", "name", "uuid"),
                   function(col) col %in% colnames(data))
    if (sum(cols) != 1) {
      stop(paste("Must specify one (and only one) of the `img`, `name`, or",
                 "`uuid` aesthetics."))
    }
    # Check supplied data types and retrieve silhouettes if need be
    if (cols["name"]) {
      if (!is.character(data$name)) {
        stop("The `name` aesthetic should be of class character.")
      }
      # Get PhyloPic for each unique name
      name_unique <- unique(data$name)
      imgs <- sapply(name_unique, function(name) {
        url <- tryCatch(get_uuid(name = name, url = TRUE),
                        error = function(cond) NA)
        if (is.na(url)) {
          warning(paste0("`name` ", '"', name, '"',
                         " returned no PhyloPic results."))
          return(NULL)
        }
        get_svg(url)
      })
      imgs <- imgs[data$name]
    } else if (cols["uuid"]) {
      if (!is.character(data$uuid)) {
        stop("The `uuid` aesthetic should be of class character.")
      }
      # Get PhyloPic for each unique uuid
      uuid_unique <- unique(data$uuid)
      imgs <- sapply(uuid_unique, function(uuid) {
        img <- tryCatch(get_phylopic(uuid),
                        error = function(cond) NULL)
        if (is.null(img)) {
          warning(paste0('"', uuid, '"', " is not a valid PhyloPic `uuid`."))
        }
        img
      })
      imgs <- imgs[data$uuid]
    } else {
      if (any(sapply(data$img, function(img) {
        !is(img, "Picture") && !is.array(img)
      }))) {
        stop(paste("The `img` aesthetic should be of class Picture (for a",
                   "vector image) or class array (for a raster image)."))
      }
      imgs <- data$img
    }
    # Calculate height as percentage of y limits
    heights <- data$size / diff(panel_params$y.range)
    grobs <- lapply(seq_len(nrow(data)), function(i) {
      if (is.null(imgs[[i]])) {
        nullGrob()
      } else {
        phylopicGrob(imgs[[i]], data$x[i], data$y[i], heights[i],
                     data$colour[i], data$alpha[i],
                     data$horizontal[i], data$vertical[i], data$angle[i])
      }
    })
    ggname("geom_phylopic", gTree(children = do.call(gList, grobs)))
  }
)

#' @importFrom grImport2 pictureGrob
#' @importFrom grid rasterGrob gList gTree
phylopicGrob <- function(img, x, y, height, color, alpha,
                         horizontal, vertical, angle) {
  # modified from add_phylopic for now
  if (horizontal || vertical) img <- flip_phylopic(img, horizontal, vertical)
  if (!is.na(angle) && angle != 0) img <- rotate_phylopic(img, angle)

  # grobify (and recolor if necessary)
  if (is(img, "Picture")) { # svg
    gp_fun <- function(pars) {
      if (!is.null(color)) {
        pars$fill <- color
      }
      pars$alpha <- alpha
      pars
    }
    # modified from
    # https://github.com/k-hench/hypoimg/blob/master/R/hypoimg_recolor_svg.R
    img_grob <- pictureGrob(img, x = x, y = y, height = height,
                            default.units = "native", expansion = 0,
                            gpFUN = gp_fun)
    img_grob <- gList(img_grob)
    img_grob <- gTree(children = img_grob)
  } else { # png
    img <- recolor_phylopic(img, alpha, color)
    img_grob <- rasterGrob(img, x = x, y = y, height = height,
                           default.units = "native")
  }
  return(img_grob)
}

#' @importFrom grid grobName
ggname <- function(prefix, grob) {
  # copied from ggplot2
  grob$name <- grobName(grob, prefix)
  grob
}
